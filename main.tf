variable "names" {
  default = ["jane","mary","peter"]
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
  #count = length(var.names)
  #name  = var.names[count.index]
  for_each = toset(var.names)
  name = each.value
}