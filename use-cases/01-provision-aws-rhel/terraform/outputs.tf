output "instance_ids" {
  description = "IDs das instâncias RHEL criadas"
  value       = [for i in aws_instance.lab_instances : i.id]
}

output "public_ips" {
  description = "IPs públicos das instâncias RHEL"
  value       = [for i in aws_instance.lab_instances : i.public_ip]
}

output "private_ips" {
  description = "IPs privados das instâncias RHEL"
  value       = [for i in aws_instance.lab_instances : i.private_ip]
}

output "bucket_data_name" {
  description = "Nome do bucket S3 de dados"
  value       = aws_s3_bucket.data.id
}

output "bucket_logs_name" {
  description = "Nome do bucket S3 de logs"
  value       = aws_s3_bucket.logs.id
}

output "vpc_id" {
  description = "ID da VPC do lab"
  value       = aws_vpc.lab_vpc.id
}
