provider "aws" {
    profile = var.profile
    region = "eu-west-1"
}

resource "aws_db_instance" "default" {
  allocated_storage = 20
  engine = "mysql"
  instance_class = "db.t2.micro"
  db_name = "products_db"
  username = "devmysql"
  password = var.password
  identifier = var.id
  publicly_accessible = true
# vpc_security_group_ids = [ "value" ] 
}