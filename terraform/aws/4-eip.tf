resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat-gateway-eip"
  }
}
