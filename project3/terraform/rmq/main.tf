provider "aws" {
  region = "eu-west-1"

}

resource "aws_instance" "rmq" {
    ami = "ami-07d8796a2b0f8d29c"
    instance_type = "t2.micro"
    key_name = "rabbitmq"
    vpc_security_group_ids = [ "sg-0b5d18ac4ab5774e0" ]

    tags = {
        Name = var.name
        Group = var.group

    }
}