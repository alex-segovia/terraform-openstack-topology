terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
    local ={
        source = "hashicorp/local"
        version = "~> 2.5.1"
    }
  }
}

resource "openstack_compute_instance_v2" "admin_vm" {
    name = var.name
    flavor_name = var.flavor
    image_name = var.image
    key_pair = openstack_compute_keypair_v2.keypair.name
    security_groups = var.security_groups
    network{
        name = var.network1_name
    }
    network{
        name = var.network2_name
    }

    user_data = <<EOF
      #cloud-config
      hostname: "ADMIN"
      manage_etc_hosts: true

      runcmd:
        - sed -i 's/#Port 22/Port 2025/' /etc/ssh/sshd_config
        - sed -i 's/^Port 22/Port 2025/' /etc/ssh/sshd_config
        - systemctl restart sshd
        - echo "Cloud-init completado en el servidor de administracion" > /var/log/admin-init.log
    EOF
}

resource "openstack_compute_keypair_v2" "keypair"{
    name = var.key_pair
}

resource "local_file" "vm_private_key" {
  content = openstack_compute_keypair_v2.keypair.private_key
  filename = "${path.root}/keys/${openstack_compute_keypair_v2.keypair.name}.pem"
  file_permission = "0644"
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = "ExtNet"
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc_vm" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.admin_vm.id
}