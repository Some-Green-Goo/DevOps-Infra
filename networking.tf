# Create VPC
resource "aws_vpc" "infra" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = var.tags
}

# Create a Subnet
resource "aws_subnet" "infra" {
  vpc_id            = aws_vpc.infra.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.infra]

tags = var.tags
}

# Create Internet Gateway
resource "aws_internet_gateway" "infra" {
  vpc_id = aws_vpc.infra.id

tags = var.tags
}

# Create Route Table
resource "aws_route_table" "infra" {
  vpc_id = aws_vpc.infra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra.id
  }

tags = var.tags
}

resource "aws_route_table_association" "infra" {
  subnet_id      = aws_subnet.infra.id
  route_table_id = aws_route_table.infra.id
}

