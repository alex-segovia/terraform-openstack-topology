terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_images_image_v2" "image" {
  name = var.image_name
  local_file_path = "${path.module}/${var.image_file_name}"
  container_format = var.container_format
  disk_format = var.disk_format
  visibility = var.visibility
}