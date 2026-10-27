locals {
  public_subnets = {
    for key, config in var.subnet_config : key => config if config.public
  }
    private_subnets = {
    for key, config in var.subnet_config : key => config if config.public == false
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = var.vpc_config.name
  }

}

resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition = contains(data.aws_availability_zones.available.names, each.value.az)
      #error_message = "AZ is not in the available zones"
      error_message = <<-EOT
      Subnet key: ${each.key} has invalid az "${each.value.az}"
      AZ Region: "${data.aws_availability_zones.available.id}" supports the following:
      [${join(", ", data.aws_availability_zones.available.names)}]
      EOT
    }
  }
}

resource "aws_internet_gateway" "this" {
  count = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  # if could > 0, then we only want 1 IGW
}

resource "aws_route_table" "public_rtb" {
  count = length(local.public_subnets) > 0 ? 1 : 0
  # if could > 0, then we only want 1 IGW
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id

  }
}

resource "aws_route_table_association" "this" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}

output "subnets" {
  value ={
    for s, subnet in aws_subnet.this: s => subnet.id
  } 
}