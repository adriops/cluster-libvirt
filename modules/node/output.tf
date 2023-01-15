output "ips" {
  description = "Nodes ip"
  value = [ for node in libvirt_domain.default: "${node.name}: ${node.network_interface.0.addresses.0}" ]
}
