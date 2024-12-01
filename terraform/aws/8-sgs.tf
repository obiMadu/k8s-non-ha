# Bastion Host Security Group
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = var.ssh_port_bastion
    to_port     = var.ssh_port_bastion
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Controlplane Security Group
resource "aws_security_group" "controlplane" {
  name        = "controlplane-sg"
  description = "Security group for Kubernetes control plane nodes"
  vpc_id      = aws_vpc.main_vpc.id # Assume you have a VPC defined

  # Kubernetes API server
  ingress {
    description = "Kubernetes API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
  }

  # etcd server client API
  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true
  }

  # Kubelet API
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  # kube-scheduler
  ingress {
    description = "kube-scheduler"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    self        = true
  }

  # kube-controller-manager
  ingress {
    description = "kube-controller-manager"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    self        = true
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "controlplane-sg"
  }
}

resource "aws_security_group" "workernode" {
  name        = "workernode-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = aws_vpc.main_vpc.id # Assume you have a VPC defined

  # SSH Port
  ingress {
    description = "SSH Port"
    from_port   = var.ssh_port_workernodes
    to_port     = var.ssh_port_workernodes
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubelet API
  ingress {
    description     = "Kubelet API"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.controlplane.id]
  }

  # kube-proxy
  ingress {
    description = "kube-proxy"
    from_port   = 10256
    to_port     = 10256
    protocol    = "tcp"
    self        = true
  }

  # NodePort Services
  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "workernode-sg"
  }
}
