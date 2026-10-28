terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. VPC Principal
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-exercici2"
  }
}

# 2. Subxarxes (totes a us-east-1a)
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/25"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.30.0/23"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-B"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.33.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-C"
  }
}

# Data source per obtenir l'última AMI d'Amazon Linux 2023
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-amd64"]
  }
}

# 3. Desplegament de les 6 instàncies EC2 (2 a cada subxarxa)
resource "aws_instance" "ec2_subnet_a" {
  count         = 2
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id

  tags = {
    Name = "EC2-Subnet-A-${count.index + 1}"
  }
}

resource "aws_instance" "ec2_subnet_b" {
  count         = 2
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_b.id

  tags = {
    Name = "EC2-Subnet-B-${count.index + 1}"
  }
}

resource "aws_instance" "ec2_subnet_c" {
  count         = 2
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_c.id

  tags = {
    Name = "EC2-Subnet-C-${count.index + 1}"
  }
}
