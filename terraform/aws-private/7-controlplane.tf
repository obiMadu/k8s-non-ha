resource "aws_instance" "controlplane" {
  ami           = "ami-05c172c7f0d3aed00"
  instance_type = var.controlplane_instance_type
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.controlplane.id]

  user_data = templatefile("./userdata.tpl", {
    pubkey   = file("../../key-controlplane.pub"),
    hostname = "controlplane",
  })

  tags = {
    Name = "controlplane"
  }
}
