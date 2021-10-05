output "machine_names" {
  value = consul_node.consul_node_lb_dns.*.name
}

output "primary_ip" {
  value = consul_node.consul_node_lb_dns.*.address
}
