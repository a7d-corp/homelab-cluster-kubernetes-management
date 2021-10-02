pm_host_port    = 8006
pm_tls_insecure = true

instance_domain = "" # CHANGEME

clone         = "template-ubuntu-2004-base-image"
target_node   = "" # CHANGEME
resource_pool = "" # CHANGEME

os_type                 = "cloud-init"
cloudinit_cdrom_storage = "nfs-cloudinit"
citemplate_storage      = "nfs-cloudinit"

resource_cpu_cores   = 1
resource_cpu_sockets = 1
resource_memory      = 2048

# network config
network_model = "virtio"

# primary nic config
net0_network_bridge  = "vmbr0"
net0_vlan_tag        = 1001
net0_network_cidr    = "172.25.0.0/23"
net0_network_netmask = 23

searchdomain = "analbeard.com"
nameserver   = "1.1.1.1"
