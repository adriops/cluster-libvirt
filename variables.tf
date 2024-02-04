# Network
variable "net_name" {
  type    = string
  default = "cluster-net"
}

variable "net_domain" {
  type    = string
  default = "cluster.local"
}

variable "net_dns_forwarder" {
  type    = string
  default = "8.8.8.8"
}

# Storage
variable "pool_name" {
  type    = string
  default = "cluster"
}

variable "pool_path" {
  type    = string
  default = "/var/lib/libvirt/cluster_pool"
}

# Resources of nodes
variable "nodes_quantity" {
  type    = number
  default = 1
}

variable "nodes_name" {
  type    = string
  default = "node"
}

variable "nodes_cpu" {
  type    = number
  default = 2
}

variable "nodes_ram" {
  type    = string
  default = "4096"
}

variable "nodes_disk_size" {
  type    = number
  default = 16106127360 #15GiB in bytes
}

variable "nodes_cloud_image_path" {
  type    = string
  default = "/var/lib/libvirt/images/AlmaLinux-8-GenericCloud-8.7-20221111.x86_64.qcow2"
}
