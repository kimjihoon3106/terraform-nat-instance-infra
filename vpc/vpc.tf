resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.prefix}-igw"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = aws_subnet.public_subnet_a.id
  tags = {
    "Name" = "${var.prefix}-nat-gateway"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_public_a
  availability_zone = "${var.region}a"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.prefix}-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_public_b
  availability_zone = "${var.region}b"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.prefix}-public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_private_a
  availability_zone = "${var.region}a"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    "Name" = "${var.prefix}-private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_private_b
  availability_zone = "${var.region}b"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    "Name" = "${var.prefix}-private-subnet-b"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    "Name" = "${var.prefix}-public-rt"
  }
}

resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" = "${var.prefix}-private-rt-a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.prefix}-private-rt-b"
  }
}

resource "aws_route_table_association" "public_subnet_route_association_a" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_route_association_b" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_association_a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_route_association_b" {
  subnet_id = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}