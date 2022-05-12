terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0"
    }
  }
}

resource "aws_vpc" "default" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = cidrsubnet("${var.cidr_block}",4,0)
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.default.id
  cidr_block = cidrsubnet("${var.cidr_block}",4,2)
  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
  
}

resource "aws_security_group" "default" {
  name = "${var.vpc_name}-seuritygroup"
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_security_group_rule" "egress-all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id  
}

resource "aws_security_group_rule" "ssh-all" {
  type = "ingress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id  
}

resource "aws_security_group_rule" "udp-500" {
  type = "ingress"
  from_port = "500"
  to_port = "500"
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id  
}

resource "aws_security_group_rule" "udp-4500" {
  type = "ingress"
  from_port = "4500"
  to_port = "4500"
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id  
}

data "aws_ami" "default" {
  owners = ["aws-marketplace"]
  filter {
    name = "name"
    values = [var.csr_ami_filter]
  }
}

resource "aws_instance" "default" {
  ami = data.aws_ami.default.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  key_name = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = {
    Name = "${var.vpc_name}-csr-instance"
  }
}

resource "aws_eip" "default" {
  instance = aws_instance.default.id
  vpc = true
  depends_on = [
    aws_internet_gateway.default
  ]
}