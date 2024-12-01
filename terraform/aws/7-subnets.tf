# Create a public subnet for natgw, just beause i can :wink:
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "172.16.9.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet A - for the Controlplane
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "subnet-a"
  }
}

# Associate Subnet A with private route table
resource "aws_route_table_association" "private_subnet_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.private.id
}

# Public Subnet B - for the Workers
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-b"
  }
}

# Associate Subnet B with public route table
resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public.id
}
