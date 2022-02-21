resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    instance_domain = var.instance_domain
    machine_names   = consul_node.consul_node_lb_dns.*.name
    machine_ips     = consul_node.consul_node_lb_dns.*.address
    vip_ip          = local.vip_ip
  })

  filename        = "ansible/inventory.ini"
  file_permission = "0644"
}
