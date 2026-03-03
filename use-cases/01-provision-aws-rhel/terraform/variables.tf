variable "aws_region" {
  description = "Região AWS onde as instâncias RHEL serão criadas"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instância EC2 para as máquinas RHEL"
  type        = string
  default     = "t3.small"
}

variable "instance_count" {
  description = "Quantidade de instâncias RHEL a serem criadas"
  type        = number
  default     = 4
}

variable "name_prefix" {
  description = "Prefixo para o nome (tag Name) das instâncias"
  type        = string
  default     = "eap-demo-rhel"
}

