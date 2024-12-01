resource "local_file" "ansible_inventory_create" {
  content  = <<EOF
[controlplane]
${aws_instance.controlplane.public_ip}

[workernodes]
%{for index, worker in aws_instance.workernodes~}
${worker.public_ip}
%{endfor~}

EOF
  filename = "${path.root}/../../ansible/inventory.ini"
}

# Controlplane files
data "template_file" "ansible_groupvars_controlplane" {
  template = file("${path.root}/../../ansible/group_vars/controlplane.tpl")
  vars     = {}
}

resource "local_file" "ansible_groupvars_controlplane" {
  content  = data.template_file.ansible_groupvars_controlplane.rendered
  filename = "${path.root}/../../ansible/group_vars/controlplane.yml"
}

# Workernodes files
data "template_file" "ansible_groupvars_workernodes" {
  template = file("${path.root}/../../ansible/group_vars/workernodes.tpl")
  vars     = {}
}

resource "local_file" "ansible_groupvars_workernodes" {
  content  = data.template_file.ansible_groupvars_workernodes.rendered
  filename = "${path.root}/../../ansible/group_vars/workernodes.yml"
}
