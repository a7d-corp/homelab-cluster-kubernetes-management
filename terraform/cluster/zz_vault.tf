data "vault_generic_secret" "terraform_pve_auth" {
  path = "proxmox/terraform-pve-auth"
}

data "vault_generic_secret" "terraform_pve_ssh" {
  path = "proxmox/terraform-pve-ssh"
}

data "vault_generic_secret" "terraform_generic" {
  path = "proxmox/terraform-pve-config"
}

data "vault_generic_secret" "terraform_consul" {
  path = "proxmox/terraform-consul"
}
