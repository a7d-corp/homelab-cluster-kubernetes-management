hostname : "${instance_role}${count_id}-${name_stub}.${instance_domain}"
users:
  - name: packer
    expiredate: '2001-01-01'
  - name: deploy
    gecos: "terraform deploy user"
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMt+vCGHNmBKcwai0B/QJOxEsfsmV3AKVNGQg8e5CHv

bootcmd:
  - [ /usr/local/bin/resize-lvm ]
