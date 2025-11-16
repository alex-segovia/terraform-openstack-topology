terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

/*resource "openstack_blockstorage_volume_v3" "volume" {
  name = var.volume_name
  size = var.volume_size
}*/

resource "openstack_compute_instance_v2" "storage_vm" {
    name = var.name
    flavor_name = var.flavor
    image_name = var.image
    security_groups = var.security_groups
    network{
        name = var.network2_name
    }
}

/*resource "openstack_compute_volume_attach_v2" "volume_attach" {
  instance_id = openstack_compute_instance_v2.storage_vm.id
  volume_id = openstack_blockstorage_volume_v3.volume.id
}*/