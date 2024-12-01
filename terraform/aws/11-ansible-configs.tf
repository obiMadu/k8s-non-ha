resource "local_file" "ansible_inventory_create" {
  content  = <<EOF
[bastion]
${aws_instance.bastion.public_ip}

[controlplane]
${aws_instance.controlplane.private_ip}

[workernodes]
%{for index, worker in aws_instance.workernodes~}
${worker.public_ip}
%{endfor~}

EOF
  filename = "${path.root}/../../ansible/inventory.ini"
}

# Bastion Host files
data "template_file" "ansible_groupvars_bastion" {
  template = file("${path.root}/../../ansible/group_vars/bastion.tpl")
  vars = {
    ssh-port = var.ssh_port_bastion
  }
}

resource "local_file" "ansible_groupvars_bastion" {
  content  = data.template_file.ansible_groupvars_bastion.rendered
  filename = "${path.root}/../../ansible/group_vars/bastion.yml"
}

# Controlplane files
data "template_file" "ansible_groupvars_controlplane" {
  template = file("${path.root}/../../ansible/group_vars/controlplane.tpl")
  vars = {
    ssh-port          = var.ssh_port_controlplane,
    bastion_public_ip = aws_instance.bastion.public_ip,
    bastion_ssh_port  = var.ssh_port_bastion
  }
}

resource "local_file" "ansible_groupvars_controlplane" {
  content  = data.template_file.ansible_groupvars_controlplane.rendered
  filename = "${path.root}/../../ansible/group_vars/controlplane.yml"
}

# Workernodes files
data "template_file" "ansible_groupvars_workernodes" {
  template = file("${path.root}/../../ansible/group_vars/workernodes.tpl")
  vars = {
    ssh-port = var.ssh_port_workernodes
  }
}

resource "local_file" "ansible_groupvars_workernodes" {
  content  = data.template_file.ansible_groupvars_workernodes.rendered
  filename = "${path.root}/../../ansible/group_vars/workernodes.yml"
}
