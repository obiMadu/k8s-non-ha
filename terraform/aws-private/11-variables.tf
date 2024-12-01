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
