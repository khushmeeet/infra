terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }

  backend "s3" {
    bucket = var.tf_state_bucket
    key    = "aws/infra.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "bucket1" {
  bucket = var.pg_backup_bucket
}

resource "aws_s3_bucket_public_access_block" "bucket1_access" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket1_versioning" {
  bucket = aws_s3_bucket.bucket1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket1_sse" {
  bucket = aws_s3_bucket.bucket1.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  encryption_type      = "KMS"

  image_scanning_configuration {
    scan_on_push = true
  }
}
