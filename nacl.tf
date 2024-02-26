##### Airgapped Subnets NACL
resource "aws_network_acl" "airgapped_nacl" {
  count  = length(var.airgapped_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.name_prefix}nacl-airgapped" }, var.tags)
}

resource "aws_network_acl_rule" "airgapped_nacl_ingress_rules" {
  count          = length(var.airgapped_subnets) > 0 ? length(var.private_subnets) : 0
  network_acl_id = aws_network_acl.airgapped_nacl[0].id
  rule_number    = 100 + count.index
  cidr_block     = aws_subnet.private_subnets[count.index].cidr_block
  protocol       = "-1"
  rule_action    = "allow"
  egress         = false
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "airgapped_nacl_egress_rules" {
  count          = length(var.airgapped_subnets) > 0 ? length(var.private_subnets) : 0
  network_acl_id = aws_network_acl.airgapped_nacl[0].id
  rule_number    = 100 + count.index
  cidr_block     = aws_subnet.private_subnets[count.index].cidr_block
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  from_port      = 0
  to_port        = 0
}


resource "aws_network_acl_association" "airgapped_nacl_assc" {
  count          = length(var.airgapped_subnets) > 0 ? length(var.airgapped_subnets) : 0
  network_acl_id = aws_network_acl.airgapped_nacl[0].id
  subnet_id      = aws_subnet.airgapped_subnets[count.index].id
}
