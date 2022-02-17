provider "aws" {
    profile = "default"
    region = "eu-west-1"
}
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "production"
    }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}
# resource "aws_route_table" "prod-route-table" {
#   vpc_id = aws_vpc.prod-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "Prod"
#   }
# }
resource "aws_subnet" "subnet-1"{
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "prod-subnet"
    }
}
# resource "aws_route_table_association" "a" {
#     subnet_id      = aws_subnet.subnet-1.id
#     route_table_id = aws_route_table.prod-route-table.id
# }
resource "aws_security_group" "allow_web" {
    name        = "allow_web_traffic"
    description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id
  
    ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
  
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  
    tags = {
      Name = "allow_web"
    }
}
resource "aws_network_interface" "web-server-nic" {
    subnet_id       = aws_subnet.subnet-1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id]
}
# resource "aws_eip" "one" {
#     vpc                       = true
#     network_interface         = aws_network_interface.web-server-nic.id
#     associate_with_private_ip = "10.0.1.50"
#     depends_on = [aws_internet_gateway.gw]
#}
resource "aws_instance" "web-server-instance"{
    ami = "ami-07d8796a2b0f8d29c"
    instance_type = "t2.micro"
    availability_zone = "eu-west-1a"
    key_name = "mydevops"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }
    
  #  user_data = "${file("user-data-apache.sh")}"

    tags = {
        Name = "web-server"
    }
}