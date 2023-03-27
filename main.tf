data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "Main" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.Main.id
  cidr_block        = values(var.public_subnets)[count.index]
#   availability_zone = element(["${data.aws_availability_zones.available}a", "${data.aws_availability_zones.available}b", "${data.aws_availability_zones.available}c", "${data.aws_availability_zones.available}d"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = keys(var.public_subnets)[count.index]
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.Main.id
  cidr_block        = values(var.private_subnets)[count.index]
#   availability_zone = element(["${data.aws_availability_zones.available}a", "${data.aws_availability_zones.available}b", "${data.aws_availability_zones.available}c", "${data.aws_availability_zones.available}d"], count.index)
availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = keys(var.private_subnets)[count.index]
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags = {
    Name = "PrivateRT"
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PrivateRTassociation" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_eip" "nateIP" {
  vpc = true
}

resource "aws_nat_gateway" "NATgw" {
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.nateIP.id
}

