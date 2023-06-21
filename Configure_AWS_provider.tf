# Configure AWS provider
provider "aws" {
  region = "us-east-1"

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway (IGW)
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Subnets
resource "aws_subnet" "web_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "web_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "app_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b"
}

# Create Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Routes
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "web_subnet_association_1" {
  subnet_id      = aws_subnet.web_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "web_subnet_association_2" {
  subnet_id      = aws_subnet.web_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "app_subnet_association_1" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "app_subnet_association_2" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_subnet_association_1" {
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_subnet_association_2" {
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.private_subnet.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "my_eip" {
  vpc = true
}
