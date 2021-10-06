resource "macaddress" "lb_net0_mac" {
  count = local.lb_count
}

resource "consul_node" "consul_node_lb_dns" {
  count = local.lb_count

  address = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset)
  name    = "ha-lb${count.index}-${local.name_stub}"
  meta = {
    "external-node" : "true",
    "external-probe" : "true"
  }
}

resource "consul_service" "consul_service_lb_ssh" {
  count = local.lb_count

  name    = "ha-lb${count.index}-${local.name_stub}-ssh"
  address = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset)
  node    = consul_node.consul_node_lb_dns[count.index].name
  port    = 22

  check {
    check_id = "ha-lb${count.index}-${local.name_stub}:ssh"
    name     = "SSH TCP on port 22"
    tcp      = "${cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset)}:22"
    interval = "10s"
    timeout  = "2s"
  }
}

resource "consul_node" "consul_node_vip" {
  address = local.vip_ip
  name    = "ha-lb-vip-${local.name_stub}"
  meta = {
    "external-node" : "true",
    "external-probe" : "true"
  }
}

resource "consul_service" "consul_service_vip_port" {
  name    = "ha-lb-vip-${local.name_stub}"
  address = local.vip_ip
  node    = consul_node.consul_node_vip.name
  port    = local.vip_port

  check {
    check_id = "ha-lb-vip-${local.name_stub}:${local.vip_port}"
    name     = "TCP on port ${local.vip_port}"
    tcp      = "${local.vip_ip}:${local.vip_port}"
    interval = "10s"
    timeout  = "2s"
  }
}

module "cloudinit_template" {
  count = local.lb_count

  source = "github.com/glitchcrab/terraform-module-proxmox-cloudinit-template"

  conn_type   = var.connection_type
  conn_user   = data.vault_generic_secret.terraform_pve_ssh.data["user"]
  conn_target = local.pm_host_address

  instance_name = "ha-lb${count.index}-${local.name_stub}.${var.instance_domain}"

  snippet_root_dir  = local.snippet_root_dir
  snippet_dir       = local.snippet_dir
  snippet_file_base = replace("ha-lb${count.index}-${local.name_stub}.${var.instance_domain}", ".", "-")

  primary_network = {
    gateway = local.primary_ip_gateway
    ip      = cidrhost(var.net0_network_cidr, count.index + local.primary_ip_offset)
    macaddr = upper(macaddress.lb_net0_mac[count.index].address)
    netmask = var.net0_network_netmask
  }

  search_domains = ["${var.instance_domain}", "analbeard.com"]
  dns_servers    = local.dns_servers

  user_data_blob = templatefile("${path.module}/templates/cloud-init-userdata.tpl", {
    count_id        = count.index
    name_stub       = local.name_stub
    instance_domain = var.instance_domain
  })
}

module "lb_instances" {
  count = local.lb_count

  source     = "github.com/glitchcrab/terraform-module-proxmox-instance"
  depends_on = [module.cloudinit_template]

  pve_instance_name        = "ha-lb${count.index}-${local.name_stub}.${var.instance_domain}"
  pve_instance_description = "kubernetes managment cluster loadbalancer"
  vmid                     = local.vmid_base + count.index

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
    macaddr = upper(macaddress.lb_net0_mac[count.index].address)
  }]

  disks = [{
    type    = "scsi"
    storage = "local-lvm"
    size    = "10G"
  }]

  snippet_dir             = local.snippet_dir
  snippet_file_base       = replace("ha-lb${count.index}-${local.name_stub}.${var.instance_domain}", ".", "-")
  os_type                 = var.os_type
  cloudinit_cdrom_storage = var.cloudinit_cdrom_storage
  citemplate_storage      = var.citemplate_storage

  instance_domain = var.instance_domain
  searchdomain    = var.instance_domain
  nameserver      = var.nameserver
}
