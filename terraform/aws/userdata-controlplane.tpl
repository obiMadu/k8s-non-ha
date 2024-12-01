#cloud-config
ssh_pwauth: false

users:
  - name: ansible
    gecos: Ansible User
    groups: [sudo, docker]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - "${pubkey}"
