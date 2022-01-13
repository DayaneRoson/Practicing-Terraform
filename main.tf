
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

//HTTP SERVER - SG
//SG -> 80 TCP, 22 CIDR["172.30.112/22"]

resource "aws_default_vpc" "default" {

}


resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "public-access"
    from_port        = 80
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "public-access"
      from_port        = 22
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      protocol         = "tcp"
      security_groups  = null
      self             = false
      to_port          = 22
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "public-access"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = -1
    security_groups  = null
    self             = false
    to_port          = 0
  }]

  tags = {
    "gato" = "branquinha"
  }
}

resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  vpc_id = aws_default_vpc.default.id
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "public-access"
    from_port        = 80
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 80
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "public-access"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = -1
    security_groups  = null
    self             = false
    to_port          = 0
  }]

}

resource "aws_elb" "elb" {
  name            = "elb"
  subnets         = data.aws_subnet_ids.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = values(aws_instance.http_servers).*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "http_servers" {
  #ami                    = "ami-08e4e35cccc6189f4"ami-08e4e35cccc6189f4
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "teste-terraform"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  for_each  = data.aws_subnet_ids.default_subnets.ids
  subnet_id = each.value

  tags = {
    "name" = "http_servers_${each.value}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Ola eu sou a DayVops, hackeando voce por ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}
