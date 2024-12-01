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

# Write the SSH configuration
write_files:
  - path: /etc/ssh/sshd_config
    content: |
      # Hardened sshd_config
      Port ${ssh_port}
      AddressFamily inet
      ListenAddress 0.0.0.0
      Protocol 2
      HostKey /etc/ssh/ssh_host_rsa_key
      HostKey /etc/ssh/ssh_host_ecdsa_key
      HostKey /etc/ssh/ssh_host_ed25519_key
      SyslogFacility AUTH
      LogLevel VERBOSE
      LoginGraceTime 30s
      PermitRootLogin no
      StrictModes yes
      MaxAuthTries 3
      MaxSessions 5
      KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
      PubkeyAuthentication yes
      PermitEmptyPasswords no
      ChallengeResponseAuthentication no
      UsePAM yes
      AllowAgentForwarding yes
      AllowTcpForwarding yes
      X11Forwarding no
      PermitTunnel no
      PermitUserEnvironment no
      ClientAliveInterval 300
      ClientAliveCountMax 2
      UseDNS no
      PrintMotd no
      Subsystem sftp /usr/lib/openssh/sftp-server -f AUTHPRIV -l INFO

# Restart SSH service
runcmd:
  - systemctl restart ssh
