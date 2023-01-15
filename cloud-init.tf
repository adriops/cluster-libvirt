data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.cfg")
}

resource "libvirt_cloudinit_disk" "common-init" {
  name      = "common-init.iso"
  user_data = data.template_file.user_data.rendered
  pool      = libvirt_pool.default.name
}
