variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "controlplane_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "worker_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "workernodes_count" {
  type    = number
  default = 2
}

variable "ssh_port_bastion" {
  type    = number
  default = 22
}

variable "ssh_port_controlplane" {
  type    = number
  default = 22
}

variable "ssh_port_workernodes" {
  type    = number
  default = 22
}
