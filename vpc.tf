locals {
  public_nat_subnets    = { for subnet in var.public_subnets : subnet.availability_zone => subnet if subnet.nat_gateway }
  public_no_nat_subnets = { for index, subnet in var.public_subnets : index => subnet if !subnet.nat_gateway }
}

#### VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr
  tags                 = merge({ Name = "${var.name_prefix}${var.vpc.name}" }, var.tags)
  enable_dns_hostnames = var.vpc_option.enable_dns_hostnames
  enable_dns_support   = var.vpc_option.enable_dns_support
}

#### Public Subnets (NAT)
resource "aws_subnet" "public_nat_subnets" {
  for_each          = local.public_nat_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${data.aws_region.current.name}${each.value.availability_zone}"
  tags              = merge({ Name = "${var.name_prefix}${each.value.name}", NatGateway = "true" }, var.tags)
}
resource "aws_subnet" "public_no_nat_subnets" {
  for_each          = local.public_no_nat_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${data.aws_region.current.name}${each.value.availability_zone}"
  tags              = merge({ Name = "${var.name_prefix}${each.value.name}", NatGateway = "false" }, var.tags)
}

#### Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = "${data.aws_region.current.name}${var.private_subnets[count.index].availability_zone}"
  tags              = merge({ Name = "${var.name_prefix}${var.private_subnets[count.index].name}" }, var.tags)
}

#### Airgapped Subnets
resource "aws_subnet" "airgapped_subnets" {
  count             = length(var.airgapped_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.airgapped_subnets[count.index].cidr
  availability_zone = "${data.aws_region.current.name}${var.airgapped_subnets[count.index].availability_zone}"
  tags              = merge({ Name = "${var.name_prefix}${var.airgapped_subnets[count.index].name}" }, var.tags)
}
