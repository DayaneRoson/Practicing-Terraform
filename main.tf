terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~>3.70"
      }
  }
}

#Already configured the AWS credentials using environments variables
#Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

#Resources I want to alocate in the cloud
resource "aws_s3_bucket" "leninha_bucket" {
  bucket = "leninha-bucket-terraform"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "branquinha_bucket" {
  bucket = "branquinha-bucket-terraform"
  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "my_first_iam_user" {
  name = "my-first-iam-user-2"
}