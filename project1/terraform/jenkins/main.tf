provider "aws" {

    region = "eu-west-1"
}

variable "name" {
    description = "Name the instance on deploy"
}

resource "aws_instance" "mydevops_jenkins"{
    ami = "ami-07d8796a2b0f8d29c"
    instance_type = "t2.micro"
    key_name = "mydevops"
    security_groups = [
    "allow_ssh", 
    "allow_web",
    ]

    tags = {
        Name = "${var.name}"
    }
}