##### Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.name_prefix}igw" }, var.tags)
}

#### Elastic IP
resource "aws_eip" "eips" {
  for_each = local.public_nat_subnets
  tags     = merge({ Name = "${var.name_prefix}eip-nat-az${local.availability_zone_code[each.key]}" }, var.tags)
}

#### NAT Gateway
resource "aws_nat_gateway" "nats" {
  for_each      = local.public_nat_subnets
  allocation_id = aws_eip.eips[each.key].id
  subnet_id     = aws_subnet.public_nat_subnets[each.key].id
  tags          = merge({ Name = "${var.name_prefix}nat-az${local.availability_zone_code[each.key]}" }, var.tags)
  depends_on    = [aws_subnet.public_nat_subnets, aws_eip.eips]
}
