import boto3
import csv
import json
import os
import time
from threading import Thread
import traceback

import settings
from app import models, db, path_db
from app.models import DBModel


def read_queue(queue_name):

    # long polling https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-short-and-long-polling.html#sqs-long-polling
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sqs.html#SQS.Client.list_queues
    # https://github.com/awsdocs/aws-doc-sdk-examples/blob/master/python/example_code/sqs/message_wrapper.py

    messages = []

    sqs = boto3.resource('sqs', region_name=settings.region)
    queue = sqs.get_queue_by_name(QueueName=queue_name)

    more_messages = True
    while more_messages:
        queue_args = {'MaxNumberOfMessages': 10, 'WaitTimeSeconds': 10}
        received_messages = queue.receive_messages(**queue_args)

        for message in received_messages:
            try:
                data = json.loads(message.body)
                for i in data['Records']:
                    if 's3' in i:
                        object_name = i['s3']['object']['key']

                        messages.append({'object_name': object_name,
                                         'path_csv': '/tmp/%s' % object_name})

            except Exception as exc:
                msg = 'Unexpected error: %s\n%s' % \
                      (str(exc), traceback.format_exc())
                print(msg)

        if received_messages:
            for message in received_messages:
                message.delete()
        else:
            more_messages = False

    return messages


def download_file(s3_bucket_name, object_name, path_csv):
    s3 = boto3.client('s3', region_name=settings.region)
    s3.download_file(s3_bucket_name, object_name, path_csv)


def parse_csv(path_csv):
    data = []

    with open(path_csv, mode='r') as infile:
        raw_data = csv.DictReader(infile, delimiter=';')
        for raw_row in raw_data:
            try:
                row = {
                    'email': raw_row['Login email'],
                    'filename': path_csv,
                    'last_name': raw_row['Last name'],
                    'first_name': raw_row['First name']
                }
                data.append(row)
            except KeyError:
                pass
                # TODO: add logging "wrong csv format"
    return data


def store_data(data):
    for row in data:
        db.session.add(DBModel(**row))
    db.session.commit()


class AppDaemon(Thread):

    def __init__(self):
        Thread.__init__(self)
        self.daemon = True

        # TODO: need fix as I need RDS here
        # create db schema
        if not os.path.exists(path_db):
            db.create_all()

    def run(self):

        # TODO: move to init
        bucket_name = settings.s3_bucket_name
        queue_name = settings.sqs_queue_name

        while True:

            messages = read_queue(queue_name)
            for msg in messages:

                object_name = msg['object_name']
                path_csv = msg['path_csv']

                # download file from bucket
                download_file(bucket_name, object_name, path_csv)

                # parse csv
                data = parse_csv(path_csv)

                # store data to db
                store_data(data)

                # TODO: add logging
                os.remove(path_csv)

            time.sleep(settings.polling_timeout)
