resource "libvirt_pool" "default" {
  type = "dir"
  name = var.pool_name
  path = var.pool_path
}
