variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_credentials" {
  description = "Path to AWS credentials file"
  type        = string
  default     = "../credentials"
}

variable "ssh_key" {
  description = "SSH keys config"
  type        = map

  default     = {
    name      = "ssh_key"
    public    = "~/.ssh/id_rsa.pub"
    private   = "~/.ssh/id_rsa"
  }
}

variable "instance_conf" {
  description = "EC2 instance config"
  type        = map

  default     = {
    ami       = "ami-0823c236601fef765"
    type      = "t2.micro"
    name      = "flaskapp-instance"
    user      = "ubuntu"
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

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "flask-instance"
}
