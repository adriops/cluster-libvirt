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

resource "libvirt_volume" "cloud-image" {
  #count    = var.quantity
  name     = "cloud-image"
  source   = var.cloud_image_path
}

resource "libvirt_volume" "system" {
  count           = var.quantity
  name            = "${var.name}-system-${count.index}.qcow2"
  #base_volume_id  = libvirt_volume.cloud-image[count.index].id
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
  cloudinit = var.cloudinit_disk_id
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
