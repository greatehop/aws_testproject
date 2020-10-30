###################################
# AWS settings
###################################

region = 'eu-west-1'
s3_bucket_name = 'flaskappbucket'
sqs_queue_name = 'flaskapp_queue'

rds_user = '123'

###################################
# App settings
###################################

path_log = '/var/log/flask_app.log'
log_level = 'INFO'

flask_args = {
    'host': '0.0.0.0',
    'port': 8080
}

polling_timeout = 15
init_timeout = 5