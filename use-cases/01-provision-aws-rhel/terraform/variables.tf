variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-2"
}

variable "instance_count" {
  description = "Número de instâncias EC2"
  type        = number
  default     = 6
}

variable "instance_types" {
  description = "Tipos das instâncias"
  type        = list(string)
  default     = ["t3.micro", "t3.micro", "t3.small", "t3.small", "t3.medium", "t3.medium"]
}

variable "key_name" {
  description = "Nome do par de chaves SSH na AWS para as instâncias"
  type        = string
  default     = "aroque-key"
}

variable "tags_common" {
  description = "Tags comuns aplicadas a todos os recursos"
  type        = map(string)
  default = {
    CostCenter        = "1234"
    Environment       = "finops-lab"
    Project           = "ansible-demo"
    owner             = "aroque"
    operating_system  = "rhel"
  }
}
