resource "macaddress" "worker_net0_mac" {
  count = local.worker_count
}

resource "macaddress" "worker_net1_mac" {
  count = local.worker_count
}

resource "consul_node" "consul_node_worker_dns" {
  count = local.worker_count

  address = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset_worker)
  name    = "worker${count.index}-${local.name_stub}"
  meta = {
    "external-node" : "true",
    "external-probe" : "true"
  }
}

resource "consul_service" "consul_service_worker_ssh" {
  count = local.worker_count

  name    = "worker${count.index}-${local.name_stub}-ssh"
  address = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset_worker)
  node    = consul_node.consul_node_worker_dns[count.index].name
  port    = 22

  check {
    check_id = "worker${count.index}-${local.name_stub}:ssh"
    name     = "SSH TCP on port 22"
    tcp      = "${cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset_worker)}:22"
    interval = "10s"
    timeout  = "2s"
  }
}

module "worker_cloudinit_template" {
  count = local.worker_count

  source = "github.com/glitchcrab/terraform-module-proxmox-cloudinit-template"

  conn_type   = var.connection_type
  conn_user   = data.vault_generic_secret.terraform_pve_ssh.data["user"]
  conn_target = local.pm_host_address

  instance_name = "worker${count.index}-${local.name_stub}.${var.instance_domain}"

  snippet_root_dir  = local.snippet_root_dir
  snippet_dir       = local.snippet_dir
  snippet_file_base = replace("worker${count.index}-${local.name_stub}.${var.instance_domain}", ".", "-")

  primary_network = {
    gateway = local.primary_ip_gateway
    ip      = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset_worker)
    macaddr = upper(macaddress.worker_net0_mac[count.index].address)
    netmask = var.net0_network_netmask
  }

  extra_networks = [{
    ips     = [cidrhost(var.net1_network_cidr, count.index + local.secondary_ip_offset_worker)]
    macaddr = upper(macaddress.worker_net1_mac[count.index].address)
    name    = "eth1"
    netmask = var.net1_network_netmask
  }]

  search_domains = ["${var.instance_domain}", "analbeard.com"]
  dns_servers    = local.dns_servers

  user_data_blob = templatefile("${path.module}/templates/cloud-init-userdata.tpl", {
    count_id        = count.index
    name_stub       = local.name_stub
    instance_domain = var.instance_domain
  })
}

module "worker_instances" {
  count = local.worker_count

  source     = "github.com/glitchcrab/terraform-module-proxmox-instance"
  depends_on = [module.worker_cloudinit_template]

  pve_instance_name        = "worker${count.index}-${local.name_stub}.${var.instance_domain}"
  pve_instance_description = "kubernetes managment cluster worker"
  vmid                     = local.vmid_base + count.index + local.vmid_offset_worker

  clone      = var.clone
  full_clone = var.full_clone
  qemu_agent = var.qemu_agent

  target_node   = element(local.host_list, count.index)
  resource_pool = var.resource_pool

  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  network_interfaces = [{
    model   = var.network_model
    bridge  = var.net0_network_bridge
    tag     = var.net0_vlan_tag
    macaddr = upper(macaddress.worker_net0_mac[count.index].address)
    }, {
    model   = var.network_model
    bridge  = var.net1_network_bridge
    tag     = var.net1_vlan_tag
    macaddr = upper(macaddress.worker_net1_mac[count.index].address)
  }]

  disks = [{
    type    = "scsi"
    storage = "local-lvm"
    size    = "15G"
  }]

  snippet_dir             = local.snippet_dir
  snippet_file_base       = replace("worker${count.index}-${local.name_stub}.${var.instance_domain}", ".", "-")
  os_type                 = var.os_type
  cloudinit_cdrom_storage = var.cloudinit_cdrom_storage
  citemplate_storage      = var.citemplate_storage

  instance_domain = var.instance_domain
  searchdomain    = var.instance_domain
  nameserver      = var.nameserver
}
