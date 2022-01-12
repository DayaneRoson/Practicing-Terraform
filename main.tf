variable "iam_user_name_prefix" {
  type    = string #any #number #bool #list #map #set #object #tuple  
  default = "my-iam-user"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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
resource "aws_iam_user" "my_iam_users" {
  count = 3
  name  = "${var.iam_user_name_prefix}-${count.index}"
}