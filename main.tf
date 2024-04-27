terraform {
    required_version = ">= 0.14"
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }

    cloud {
        organization = "crawfish"

        workspaces {
            name = "mldeploy"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}


resource "random_id" "rng" {
  keepers = {
    first = "0"
  }     
  byte_length = 8
}

resource "aws_s3_bucket" "model_bucket" {
  bucket = "model-bucket-${random_id.rng.hex}"
}

resource "aws_s3_bucket_ownership_controls" "model_bucket_control" {
  bucket = aws_s3_bucket.model_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.model_bucket_control]

  bucket = aws_s3_bucket.model_bucket.id
  acl    = "private"
}