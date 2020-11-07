## Description

You need to create Flask application that should read messages from SQS queue
with events of uploaded files at S3 bucket. You need to read message and find
file at S3 bucket, parse them and store data to SQL database.

File format is csv.

The application should work at EC2 instance.

All AWS infrastructure should be created with Terraform. All using resources
should be defined as terraform code, as well as their IAM intercommunication.


## Requirements

```
AWS (EC2/SQS/S3/RDS)
Terraform >= 0.12
Ansible >= 2.4
Python 3.x, Flask, SQLAlchemy, boto3
```

## Installation

```
git clone https://github.com/greatehop/aws_testproject.git
cd aws_testproject
```

Update YOUR_ACCESS_KEY and YOUR_SECRET_KEY at 'credentials' file.

NOTE: Flask application use 'credentials' file for accessing AWS services.

## Run

Provision infrastructure via Terraform
```
cd aws_testproject/terraform
terraform init
terraform apply
```

Open FlaskApp in browser
```
echo "http://$(terraform output public_ip)"
```

## Alternatives

To run FlaskApp locally instead of EC2 you can use:

Vagrant + Virtualbox
```
cd aws_testproject
vagrant up
```

or

localhost
```
cd aws_testproject/
virtualenv venv
source venv/bin/activate
pip install -r flask_app/requirements.txt
python flask_app/run.py
```

NOTE: both of the above solution still require for AWS SQS/S3/RDS services.

## Other

Provision via Terraform or Vagrant automatically runs Ansible that deploy Flask
application, but you can run it manually (update USER and IP)
```
cd aws_testproject/ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '<USER>' -i '<IP>,' flask_app_playbook.yml
```

## TODO

```
FlaskApp:

* add logging

* add handlers for sqs/rds/s3

* change Flask UI (filename/datetime and records)

* add daemon status

* fix code: pass config var to object

* change db to mysql

* add test upload file

* update README: "how daemon works" and "how everything works"

* add linter

* RDS or SQLite

----

Ansible:

* fix ansible playbooks (settings.py)

----

Infra:

* WSGI server ?

* Docker file ?

----

Terraform:

* add rds

* service account ?
get creds from EC2 instance metadata
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#attach-iam-role

* valid IAM ?

* get rid of duplication of aws vars (sqs, buckets) in terraform and ansible

```
