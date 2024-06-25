variable "region" {
  description = "The AWS region to deploy resources"
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "The instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "The Amazon Linux 2 AMI ID for the specified region"
  default     = "ami-0d8f6eb4f641ef691"
}

variable "s3_bucket" {
  description = "The name of the S3 bucket to store backups"
  default     = "my-backup-bucket"
}