terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~>3.70"
      }
  }
}

variable "environment" {
  default = "default"
}

locals {
  iam-user-extension = "my-user"
}

#Already configured the AWS credentials using environments variables
#Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

#Resources I want to alocate 
resource "aws_iam_user" "my_first_iam_user" {
  name = "${local.iam-user-extension}-${var.environment}"
}

