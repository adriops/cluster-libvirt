resource "libvirt_network" "default" {
  name      = var.net_name
  mode      = var.net_mode
  domain    = var.net_domain
  addresses = ["10.17.3.0/24"]
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
    local_only = false
  }
}
