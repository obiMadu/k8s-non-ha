resource "null_resource" "sleep_90s_after_servers" {
  provisioner "local-exec" {
    command = "sleep 90"
  }
  depends_on = [
    aws_instance.controlplane,
    aws_instance.workernodes
  ]
}

resource "null_resource" "ansible_playbook_run" {
  provisioner "local-exec" {
    working_dir = "../../ansible"
    command     = <<-EOT
      ansible-playbook playbook.yml \
    EOT
  }

  depends_on = [
    local_file.ansible_inventory_create,
    local_file.ansible_groupvars_controlplane,
    local_file.ansible_groupvars_workernodes,
    null_resource.sleep_90s_after_servers,
  ]
}
