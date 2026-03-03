# ----------------------------------------
# REDE, SEGURANÇA E ESTRUTURA BASE
# ----------------------------------------
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames  = true
  tags = merge(var.tags_common, {
    Name = "lab-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch  = true
  tags = merge(var.tags_common, {
    Name = "public-subnet"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
  tags   = merge(var.tags_common, {
    Name = "igw"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags_common, {
    Name = "public-rt"
  })
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "lab_sg" {
  name        = "lab-sg"
  description = "Permitir SSH e ICMP"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags_common, {
    Name = "lab-sg"
  })
}

# ----------------------------------------
# PAR DE CHAVES SSH (acesso às VMs: ssh -i aroque-key.pem ec2-user@<ip>)
# ----------------------------------------
resource "aws_key_pair" "aroque" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# ----------------------------------------
# AMI RHEL
# ----------------------------------------
data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"] # AWS RHEL official
  filter {
    name   = "name"
    values = ["RHEL-9.*-x86_64-*"]
  }
}

# ----------------------------------------
# VARIAÇÃO DE TAGS FINOPS (COSTCENTER + OWNER)
# ----------------------------------------
locals {
  finops_tags = [
    { CostCenter = "1001", owner = "Linus Torvald" },
    { CostCenter = "1002", owner = "Bill Gates" },
    { CostCenter = "1003", owner = "Steve Jobs" },
    { CostCenter = "1001", owner = "Linus Torvald" },
    { CostCenter = "1002", owner = "Bill Gates" },
    { CostCenter = "1003", owner = "Steve Jobs" },
  ]
}

# ----------------------------------------
# INSTÂNCIAS EC2
# ----------------------------------------
resource "aws_instance" "lab_instances" {
  count                       = var.instance_count
  ami                         = data.aws_ami.rhel.id
  instance_type               = var.instance_types[count.index]
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  key_name                    = var.key_name

  tags = merge(
    var.tags_common,
    local.finops_tags[count.index],
    { Name = "rhel-${count.index + 1}" }
  )
}

# ----------------------------------------
# BUCKETS S3
# ----------------------------------------
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "data" {
  bucket = "finops-lab-data-${random_id.suffix.hex}"
  tags   = merge(var.tags_common, {
    Name = "finops-lab-data"
  })
}

resource "aws_s3_bucket" "logs" {
  bucket = "finops-lab-logs-${random_id.suffix.hex}"
  tags   = merge(var.tags_common, {
    Name = "finops-lab-logs"
  })
}
