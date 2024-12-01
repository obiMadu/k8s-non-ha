# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id # Route to internet via IGW
  }

  tags = {
    Name = "public"
  }
}
