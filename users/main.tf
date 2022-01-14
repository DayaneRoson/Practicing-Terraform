terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~>3.70"
      }
  }

  backend "s3" {
    bucket = "dev-applications-backend-state-dayvops"
    #key = "07-backend-state-users-dev"
    key = "dev/07-backend-state/users/backend-state"
    region = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}

#Already configured the AWS credentials using environments variables
#Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

#Resources I want to alocate in the cloud
resource "aws_iam_user" "my_first_iam_user" {
  name = "${terraform.workspace}_backend-state-user"
}