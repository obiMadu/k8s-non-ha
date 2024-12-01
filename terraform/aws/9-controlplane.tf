resource "aws_instance" "controlplane" {
  ami           = "ami-05c172c7f0d3aed00"
  instance_type = var.controlplane_instance_type
  subnet_id     = aws_subnet.subnet_a.id

  vpc_security_group_ids = [aws_security_group.controlplane.id]

  user_data = templatefile("./userdata-controlplane.tpl", {
    pubkey   = file("../../key-controlplane.pub"),
    ssh_port = var.ssh_port_controlplane
  })

  tags = {
    Name = "controlplane"
  }
}
