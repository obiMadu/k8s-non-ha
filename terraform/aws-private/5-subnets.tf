# Create a public subnet for natgw, just beause i can :wink:
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "172.16.10.0/24"
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
