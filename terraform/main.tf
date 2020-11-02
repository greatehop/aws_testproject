terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
    region = var.region
    shared_credentials_file = "../credentials"
}

//resource "aws_key_pair" "flaskapp-sshkey" {
//  key_name   = "flaskapp-sshkey"
//  public_key = file("~/.ssh/id_rsa.pub")
//}

resource "aws_instance" "web" {
    ami = var.instance_conf.ami
    instance_type = var.instance_conf.type

    associate_public_ip_address = "true"
    //key_name = aws_key_pair.flaskapp-sshkey.public_key

    tags = {
        Name = var.instance_conf.name
    }
}

resource "aws_sqs_queue" "queue" {
  name = var.queue_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:${var.queue_name}",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.bucket.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".csv"
  }
}
