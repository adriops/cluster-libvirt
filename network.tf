resource "libvirt_network" "default" {
  name      = var.net_name
  mode      = "nat"
  domain    = var.net_domain
  addresses = ["10.17.3.0/24"]
  dhcp {
    enabled = false
  }
  dns {
    enabled = true
    local_only = false
    forwarders {
      address = var.net_dns_forwarder
    } 
  }
}
