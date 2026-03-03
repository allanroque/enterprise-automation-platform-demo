terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "rhel" {
  most_recent = true

  owners = ["309956199498"] # Conta oficial Red Hat

  filter {
    name   = "name"
    values = ["RHEL-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "rhel" {
  count         = var.instance_count
  ami           = data.aws_ami.rhel.id
  instance_type = var.instance_type
  subnet_id     = element(data.aws_subnet_ids.default.ids, 0)

  tags = {
    Name = "${var.name_prefix}-${count.index}"
  }
}

