provider "proxmox" {
  pm_api_url  = "${var.pm_host_scheme}://${local.pm_host_address}:${var.pm_host_port}${var.pm_host_path}"
  pm_user     = data.vault_generic_secret.terraform_pve_auth.data["user"]
  pm_password = data.vault_generic_secret.terraform_pve_auth.data["password"]

  pm_tls_insecure = var.pm_tls_insecure
}

provider "vault" {}

provider "consul" {
  address    = "${data.vault_generic_secret.terraform_consul.data["host"]}:8500"
  datacenter = data.vault_generic_secret.terraform_consul.data["datacenter"]
  token      = data.vault_generic_secret.terraform_consul.data["token"]
}
