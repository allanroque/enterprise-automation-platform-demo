output "instance_ids" {
  description = "IDs das instâncias RHEL criadas"
  value       = [for i in aws_instance.rhel : i.id]
}

output "public_ips" {
  description = "IPs públicos das instâncias RHEL"
  value       = [for i in aws_instance.rhel : i.public_ip]
}

output "private_ips" {
  description = "IPs privados das instâncias RHEL"
  value       = [for i in aws_instance.rhel : i.private_ip]
}

