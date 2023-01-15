module "node" {
  source             = "./modules/node"
  name               = var.nodes_name
  quantity           = var.nodes_quantity
  cloud_image_path   = var.nodes_cloud_image_path
  system_volume_size = var.nodes_disk_size
  pool               = libvirt_pool.default.name
  cpu                = var.nodes_cpu
  ram                = var.nodes_ram
  network_id         = libvirt_network.default.id
}

output "nodes-ip" {
  value = module.node.ips
}
