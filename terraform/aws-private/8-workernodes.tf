resource "aws_instance" "workernodes" {
  ami           = "ami-05c172c7f0d3aed00"
  instance_type = var.worker_instance_type
  subnet_id     = aws_subnet.public.id

  count = var.workernodes_count

  vpc_security_group_ids = [aws_security_group.workernode.id]

  user_data = templatefile("./userdata.tpl", {
    pubkey   = file("../../key-workernodes.pub"),
    hostname = "node ${count.index + 1}",
  })

  tags = {
    Name = "node ${count.index + 1}"
  }
}
