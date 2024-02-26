output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "eip_ids" {
  value = [for eip in aws_eip.eips : eip.id]
}

output "nat_gateway_ids" {
  value = [for nat in aws_nat_gateway.nats : nat.id]
}

output "airgapped_nacl_ids" {
  value = [for nacl in aws_network_acl.airgapped_nacl : nacl.id]
}

output "public_nat_subnet_ids" {
  value = [for subnet in aws_subnet.public_nat_subnets : subnet.id]
}

output "public_no_nat_subnet_ids" {
  value = [for subnet in aws_subnet.public_no_nat_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "airgapped_subnet_ids" {
  value = [for subnet in aws_subnet.airgapped_subnets : subnet.id]
}
