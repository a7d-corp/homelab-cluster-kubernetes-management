locals {
  dns_servers                = ["10.101.0.60", "10.101.0.45"]
  master_count               = 3
  name_stub                  = "k8s-mgmt"
  primary_ip_gateway         = "172.25.0.1"
  primary_ip_offset_master   = 64
  primary_ip_offset_worker   = 67
  secondary_ip_offset_master = 1
  secondary_ip_offset_worker = 4
  snippet_root_dir           = "/mnt/pve/cloudinit"
  snippet_dir                = "snippets"
  vmid_base                  = 300
  vmid_offset_master         = 3
  vmid_offset_worker         = 6
  worker_count               = 3

  host_list = ["host-01", "host-02", "host-03"]

  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
}
