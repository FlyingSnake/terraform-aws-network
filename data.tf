#### data: Public subnets
data "aws_subnets" "public_nat_subnets" {
  filter {
    name   = "tag:PublicSubnet"
    values = ["true"]
  }
  filter {
    name   = "tag:NatGateway"
    values = ["true"]
  }
}
data "aws_subnet" "public_nat_subnet" {
  for_each = toset(data.aws_subnets.public_nat_subnets.ids)
  id       = each.value
}
