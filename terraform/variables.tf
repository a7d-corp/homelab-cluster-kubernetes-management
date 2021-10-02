# proxmox provider connection config

variable "pm_host_scheme" {
  type        = string
  default     = "https"
  description = "Connection scheme for the Proxmox API."
}

variable "pm_host_port" {
  type        = number
  default     = 8006
  description = "Port for the Proxmox API."
}

variable "pm_host_path" {
  type        = string
  default     = "/api2/json"
  description = "Subpath for the Proxmox API."
}

variable "pm_tls_insecure" {
  type        = bool
  default     = false
  description = "Set to `true` if the Proxmox API is secured with a self-signed TLS certificate."
}

# network configuration

variable "net0_network_bridge" {
  type        = string
  description = "Host bridge to attach the interface to."
}

variable "net0_network_cidr" {
  type        = string
  description = ""
}

variable "net0_network_netmask" {
  type        = number
  description = ""
}

variable "net0_vlan_tag" {
  type        = number
  description = ""
}

variable "network_model" {
  type        = string
  description = "Name of the NIC model."
}

# cloudinit template configuration

variable "connection_type" {
  type        = string
  default     = "ssh"
  description = "Connection type to provision cloudinit file over."
}

# instance configuration

variable "instance_domain" {
  type        = string
  description = ""
}

variable "clone" {
  type        = string
  description = "Template image to clone."
}

variable "full_clone" {
  type        = bool
  default     = true
  description = "Create a full clone instead of a linked clone."
}

variable "qemu_agent" {
  type        = number
  default     = 1
  description = "Enable QEMU gueste agent."
}

variable "target_node" {
  type        = string
  description = ""
}

variable "resource_pool" {
  type        = string
  description = "Pool to create resources in."
}

variable "resource_cpu_cores" {
  type        = number
  default     = 1
  description = ""
}

variable "resource_cpu_sockets" {
  type        = number
  default     = 2
  description = ""
}

variable "resource_memory" {
  type        = number
  default     = 1024
  description = ""
}

variable "boot" {
  type        = string
  default     = "c"
  description = "Boot device order."
}

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = ""
}

variable "os_type" {
  type        = string
  default     = "cloud-init"
  description = ""
}

variable "cloudinit_cdrom_storage" {
  type        = string
  default     = "local-lvm"
  description = "Storage location for the generated cloudinit CDROM image."
}

variable "citemplate_storage" {
  description = "Storage for the cloudinit template files"
  type        = string
}

variable "searchdomain" {
  type        = string
  description = ""
}

variable "nameserver" {
  type        = string
  description = ""
}
