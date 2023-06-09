terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }

  backend "s3" {
    bucket = "tf-axion-infra-state"
    key    = "aws/infra.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "pg_backup_bucket" {
  bucket = var.pg_backup_bucket
}

resource "aws_s3_bucket_public_access_block" "pg_backup_bucket_access" {
  bucket                  = aws_s3_bucket.pg_backup_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "pg_backup_bucket_versioning" {
  bucket = aws_s3_bucket.pg_backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pg_backup_bucket_sse" {
  bucket = aws_s3_bucket.pg_backup_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "dogsheep_bucket" {
  bucket = var.dogsheep_bucket
}

resource "aws_s3_bucket_public_access_block" "dogsheep_bucket_access" {
  bucket                  = aws_s3_bucket.dogsheep_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "dogsheep_bucket_versioning" {
  bucket = aws_s3_bucket.dogsheep_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "dogsheep_bucket_sse" {
  bucket = aws_s3_bucket.dogsheep_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_ecr_repository" "pg_backup_ecr" {
  name                 = var.pg_backup_ecr_name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "dogsheep_ecr" {
  name                 = var.dogsheep_ecr_name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
