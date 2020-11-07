###################################
# AWS settings
###################################

# AWS region
region = 'eu-west-1'

# S3 bucket name
s3_bucket_name = 'flaskappbucket'

# SQS queue name for notification from S3 bucket
sqs_queue_name = 's3-event-notification-queue'

# SQS queue settings
sqs_queue_args = {
    'MaxNumberOfMessages': 10,
    'WaitTimeSeconds': 10
}

# RDS settings
# rds_user = 'flaskappuser'
# rds_pass = ''
# rds_db = 'flaskappdb'
# rds_host = ''

###################################
# App settings
###################################

# Path for Flask log file
path_log = '/var/log/flask_app.log'

# Log level for Flask log file
log_level = 'INFO'

# Path for temporary downloaded files from S3
path_tmp_dir = '/tmp/flask_app/'

# Flask network settings
flask_args = {
    'host': '0.0.0.0',
    'port': 8080
}

# Timeout for main loop (in seconds)
polling_timeout = 15

# Timeout for initial run (in seconds)
init_timeout = 5
