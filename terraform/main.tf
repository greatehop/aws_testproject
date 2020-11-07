terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = var.region
  shared_credentials_file = var.aws_credentials
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key.name
  public_key = file(var.ssh_key.public)
}

resource "aws_security_group" "instance" {

  name = var.security_group_name

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask app access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP access from anywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "web" {
    ami = var.instance_conf.ami
    instance_type = var.instance_conf.type
    vpc_security_group_ids = [aws_security_group.instance.id]
    associate_public_ip_address = "true"
    key_name = aws_key_pair.ssh_key.key_name
    //user_data = file("userdata.sh")

    tags = {
        Name = var.instance_conf.name
    }

  provisioner "remote-exec" {

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.instance_conf.user
      private_key = file(var.ssh_key.private)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.instance_conf.user} -i '${self.public_ip},' ../ansible/flask_app_playbook.yml"
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
