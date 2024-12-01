# Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami           = "ami-05c172c7f0d3aed00"
  instance_type = var.bastion_instance_type

  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = aws_subnet.public.id

  user_data = templatefile("./userdata-controlplane.tpl", {
    pubkey   = file("../../key-controlplane.pub"),
    ssh_port = var.ssh_port_bastion
  })

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}
