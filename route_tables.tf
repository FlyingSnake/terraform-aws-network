#### Public Subnet Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.name_prefix}rt-pub" }, var.tags)
}
resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_nat_route_assc" {
  for_each       = aws_subnet.public_nat_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_no_nat_route_assc" {
  for_each       = aws_subnet.public_no_nat_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}


#### Private Subnet Route Table
resource "aws_route_table" "private_route_table" {
  for_each = local.public_nat_subnets
  vpc_id   = aws_vpc.vpc.id
  tags     = merge({ Name = "${var.name_prefix}rt-pri-az${local.availability_zone_code[each.key]}" }, var.tags)
}

resource "aws_route" "private_nat_route" {
  for_each               = local.public_nat_subnets
  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nats[each.key].id
}

resource "aws_route_table_association" "private_route_assc" {
  for_each       = { for index, subnet in aws_subnet.private_subnets : index => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[substr(each.value.availability_zone, -1, 1)].id
}

#### Airgapped Subnet Route Table
resource "aws_route_table" "airgapped_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.name_prefix}rt-airgapped" }, var.tags)
}
resource "aws_route_table_association" "airgapped_nat_route_assc" {
  for_each       = { for index, subnet in aws_subnet.airgapped_subnets : index => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.airgapped_route_table.id
}
