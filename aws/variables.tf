variable "aws_access_key" {
  description = "Value of aws acces key to connect to AWS"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Value of aws secret key to connect to AWS"
  sensitive   = true
}

variable "aws_region" {
  description = "Default aws region for provisioning resources"
  default     = "us-west-1"
}

variable "pg_backup_bucket" {
  description = "Bucket name for postgres backup file"
  default     = "infra-pg-backup"
}

variable "dogsheep_bucket" {
  description = "Bucket name for datasette dogsheep db files"
  default     = "dogsheep-db"
}

variable "ecr_name" {
  description = "AWS ECR repository name"
  default     = "infra-cr"
}
