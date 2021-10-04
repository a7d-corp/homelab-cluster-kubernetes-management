pm_host_port    = 8006
pm_tls_insecure = true

instance_domain = "node.room101.a7d"

clone         = "template-ubuntu-2004-base-image"
resource_pool = "kubernetes-management-cluster"

os_type                 = "cloud-init"
cloudinit_cdrom_storage = "nfs-cloudinit"
citemplate_storage      = "nfs-cloudinit"

resource_cpu_cores   = 1
resource_cpu_sockets = 1
resource_memory      = 3072

# network config
network_model = "virtio"

# primary nic config
net0_network_bridge  = "vmbr0"
net0_vlan_tag        = 1001
net0_network_cidr    = "172.25.0.64/23"
net0_network_netmask = 23

# secondary nic config
net1_network_bridge  = "vmbr0"
net1_vlan_tag        = 1002
net1_network_cidr    = "10.201.0.1/27"
net1_network_netmask = 27

searchdomain = "analbeard.com"
nameserver   = "10.101.0.60"
