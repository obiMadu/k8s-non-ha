resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id  # This should be a public subnet

  tags = {
    Name = "main-nat-gateway"
  }
}
