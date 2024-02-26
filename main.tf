
# provider "aws" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  availability_zone_code = {
    "a" = "1"
    "b" = "2"
    "c" = "3"
    "d" = "4"
    "e" = "5"
    "f" = "6"
  }
}
