## Description


You need create Flask application that should read messages from SQS queue
with events of uploaded files at S3 bucket. You need read message and find
file at S3 bucket, parse them and store data to SQL database.
File format is csv. The application should work at EC2 instance.
All AWS infrastructure should be created with Terraform. All using resources
should be defined as terraform code, as well as their IAM intercommunication.


## Installation


Update YOUR_ACCESS_KEY and YOUR_SECRET_KEY at 'credentials' file.

TODO: get creds from EC2 instance metadata
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#attach-iam-role


## Run


    # provision infrastructure via Terraform
    git clone
    cd aws_testproject/terraform
    terraform init
    terraform

    ----

    # deploy FlaskApp via Ansible
    cd ~/projects/aws_testproject/
    ansible-playbook -i ./ansible/inventory ansible/flask_app_playbook.yml

    ----

    # run FlaskApp
    cd ~/projects/aws_testproject/
    virtualenv venv
    source venv/bin/activate
    pip install -r flask_app/requirements.txt
    python run.py

## How it works


## ToDo

add daemon + flask +
add logging
split code +
init db scheme +
change db to mysql
service account ?

WSGI server ?
get rid of duplication of aws vars (sqs, buckets) in terraform and ansible

test ansible +

run ansible from terraform
test terraform
update README
add test upload file
upload to github

# TODO: add handlers for sqs/rds/s3