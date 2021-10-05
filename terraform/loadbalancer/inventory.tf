resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    instance_domain = var.instance_domain
    machine_names   = consul_node.consul_node_lb_dns.*.name
    machine_ips     = consul_node.consul_node_lb_dns.*.address
  })

  filename = "ansible/inventory.ini"
}
