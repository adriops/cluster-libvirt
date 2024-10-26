resource "libvirt_pool" "default" {
  type = "dir"
  name = var.pool_name
  target {
    path = var.pool_path
  }
}
