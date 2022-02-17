terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = var.profile
}

resource "aws_instance" "rmq" {
    ami = "ami-07d8796a2b0f8d29c"
    instance_type = "t2.micro"
    key_name = "mydevops2"
    vpc_security_group_ids = [ "sg-0b5d18ac4ab5774e0" ]

    tags = {
        Name = var.name
        Group = var.group

    }
}