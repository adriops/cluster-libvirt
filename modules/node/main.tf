terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "~> 0.7.1"
    }
  }
}

provider "libvirt" {
  uri    = "qemu:///system"
}

data "template_file" "user_data" {
  template = file("${path.cwd}/cloud-init.cfg")
}

resource "libvirt_cloudinit_disk" "cloud-init" {
  count     = var.quantity
  name      = "cloud-init-${var.name}-${count.index}.iso"
  user_data = data.template_file.user_data.rendered
  meta_data = "local-hostname: ${var.name}-${count.index}"
  pool      = var.pool
}

resource "libvirt_volume" "cloud-image" {
  name     = "cloud-image"
  source   = var.cloud_image_path
}

resource "libvirt_volume" "system" {
  count           = var.quantity
  name            = "${var.name}-system-${count.index}.qcow2"
  base_volume_id  = libvirt_volume.cloud-image.id
  size            = var.system_volume_size
  pool            = var.pool
}

resource "libvirt_domain" "default" {
  count     = var.quantity
  name      = "${var.name}-${count.index}"
  vcpu      = var.cpu
  memory    = var.ram
  running   = true
  cloudinit = libvirt_cloudinit_disk.cloud-init[count.index].id
  disk {
    volume_id = libvirt_volume.system[count.index].id
    scsi      = "true"
  }
  network_interface {
    network_id     = var.network_id
    hostname       = "${var.name}-${count.index}"
    wait_for_lease = true
  }
}
