# terraform-aws-network

AWS Network Resource Initialization Module

## Usage

```hcl
{
  source      = "../TF-network/TF-network"
  name_prefix = "TF-"
  tags = {
    Terraform       = "true"
  }
  vpc = {
    name = "vpc"
    cidr = "10.0.0.0/16"
  }

  vpc_option = {
    enable_dns_hostnames = false
    enable_dns_support   = false
  }

  public_subnets = [
    {
      name              = "pub-sbn-az1"
      availability_zone = "a"
      cidr              = "10.0.0.0/24"
      nat_gateway       = true
    },
    {
      name              = "pub-sbn-az3"
      availability_zone = "c"
      cidr              = "10.0.1.0/24"
      nat_gateway       = true
    }
  ]

  private_subnets = [
    {
      name              = "pri-sbn-az1"
      availability_zone = "a"
      cidr              = "10.0.2.0/24"
    },
    {
      name              = "pri-sbn-az3"
      availability_zone = "c"
      cidr              = "10.0.3.0/24"
    }
  ]

  airgapped_subnets = [
    {
      name              = "airgapped-sbn-az1"
      availability_zone = "a"
      cidr              = "10.0.4.0/24"
    },
    {
      name              = "airgapped-sbn-az3"
      availability_zone = "c"
      cidr              = "10.0.5.0/24"
    }
  ]
}
```

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 5.20 |

## Input

| Name              | Description                                                                                                        | Type         |
| ----------------- | ------------------------------------------------------------------------------------------------------------------ | ------------ |
| name_prefix       | Pre Name attached to the name of the AWS resource being created                                                    | string       |
| tags              | Tags to be attached to created AWS resources                                                                       | object       |
| vpc               | vpc settings (name, cidr)                                                                                          | object       |
| vpc_options       | vpc settings (usage of dns)                                                                                        | object       |
| public_subnets    | public subnet settings (There must be one in each Availability Zone with "nat_gateway" set to true.)               | list(object) |
| private_subnets   | private subnet settings (A public subnet with "nat_gateway" set to true must exist in the same availability zone.) | list(object) |
| airgapped_subnets | airgapped subnet settings                                                                                          | list(object) |

## Output

| Name                     | Description                           | Type         |
| ------------------------ | ------------------------------------- | ------------ |
| account_id               | AWS account id                        | string       |
| aws_region               | AWS region code                       | string       |
| vpc_id                   | VPC resource id                       | string       |
| igw_id                   | Internet gateway resource id          | string       |
| eip_ids                  | Elastic IP resource ids               | list(string) |
| nat_gateway_ids          | NAT Gateway resource ids              | list(string) |
| public_nat_subnet_ids    | Public subnet ids (nat_gateway=true)  | list(string) |
| public_no_nat_subnet_ids | Public subnet ids (nat_gateway=false) | list(string) |
| private_subnet_ids       | Private subnet ids                    | list(string) |
| airgapped_subnet_ids     | Airgapped Subnet ids                  | list(string) |
| airgapped_nacl_ids       | Airgapped Subnet NACL resource ids    | list(string) |

## Resources

| Name                         | Type                          |
| ---------------------------- | ----------------------------- |
| vpc                          | aws_vpc                       |
| public_nat_subnets           | aws_subnet[]                  |
| public_no_nat_subnets        | aws_subnet[]                  |
| private_subnets              | aws_subnet[]                  |
| airgapped_subnets            | aws_subnet[]                  |
| igw                          | aws_internet_gateway          |
| eips                         | aws_eip[]                     |
| nats                         | aws_nat_gateway[]             |
| airgapped_nacl               | aws_network_acl               |
| airgapped_nacl_ingress_rules | aws_network_acl_rule[]        |
| airgapped_nacl_egress_rules  | aws_network_acl_rule[]        |
| airgapped_nacl_assc          | aws_network_acl_association[] |
