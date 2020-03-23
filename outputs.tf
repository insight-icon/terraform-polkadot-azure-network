#####
# DNS
#####
output "root_domain_name" {
  value       = var.root_domain_name
  description = "The name of the root domain"
}

output "internal_tld" {
  value       = var.internal_tld
  description = "The name of the internal domain"
}

output "public_regional_domain" {
  value       = var.create_public_regional_subdomain ? local.public_domain : ""
  description = "The public regional domain"
}

#####
# SGs
#####
output "bastion_security_group_id" {
  value       = azurerm_application_security_group.bastion_asg.*.id
  description = "Name of the application security group for the bastion host"
}

output "consul_security_group_id" {
  value       = azurerm_application_security_group.consul_asg.*.id
  description = "Name of the application security group for the Consul servers"
}

output "hids_security_group_id" {
  value       = azurerm_application_security_group.hids_asg.*.id
  description = "Name of the application security group for the HIDS group"
}

output "logging_security_group_id" {
  value       = azurerm_application_security_group.consul_asg.*.id
  description = "Name of the application security group for the logging group"
}

output "monitoring_security_group_id" {
  value       = azurerm_application_security_group.monitoring_asg.*.id
  description = "Name of the application security group for the monitoring group"
}

output "sentry_security_group_id" {
  value       = azurerm_application_security_group.sentry_node_asg.*.id
  description = "Name of the application security group for the sentry group"
}

output "vault_security_group_id" {
  value       = azurerm_application_security_group.vault_asg.*.id
  description = "Name of the application security group for the vault group"
}

#####
# VPC
#####

output "vpc_id" {
  value       = azurerm_virtual_network.vpc_network.name
  description = "The name of the VPC"
}

output "public_subnets" {
  value       = azurerm_subnet.public.*.id
  description = "The IDs of the public subnets"
}

output "private_subnets" {
  value       = azurerm_subnet.private.*.id
  description = "The IDs of the private subnets"
}

output "public_subnet_cidr_blocks" {
  value       = local.public_subnets[*]
  description = "CIDR ranges for the public subnets"
}

output "private_subnets_cidr_blocks" {
  value       = local.private_subnets[*]
  description = "CIDR ranges for the private subnets"
}
