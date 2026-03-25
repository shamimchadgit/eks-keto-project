data "aws_availability_zones" "availability" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}
# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.availability.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
# Private Subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.availability.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}
# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}
# Route Table - Public
resource "aws_route_table" "pb_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}
# Route Table Association - Public
resource "aws_route_table_association" "pb_rt_as" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.pb_rt[count.index].id
}
# Route Table - Private
resource "aws_route_table" "pr_rt" {
  count  = length(aws_nat_gateway.nat_gw)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = {
    Name = "private-rt"
  }
}
# Route Table Association - Private
resource "aws_route_table_association" "pr_rt_as" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.pr_rt[count.index].id
}

# Elastic IP
resource "aws_eip" "nat_eip" {
  count  = length(aws_subnet.public_subnet)
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  count         = length(aws_subnet.public_subnet)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }
  depends_on = [aws_internet_gateway.igw]
}