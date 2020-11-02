variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_conf" {
  description = "EC2 instance config"
  type        = map

  default     = {
    ami       = "ami-0823c236601fef765"
    type      = "t2.micro"
    name      = "flaskapp-instance"
  }
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "flaskappbucket2"
}

variable "queue_name" {
  description = "SQS queue name"
  type        = string
  default     = "s3-event-notification-queue"
}

