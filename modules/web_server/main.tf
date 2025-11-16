terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_compute_instance_v2" "web_server" {
    count = var.server_count

    name = "S${count.index+1}"
    flavor_name = var.flavor
    image_name = var.image
    security_groups = var.security_groups
    network{
        name = var.network1_name
    }

    network{
        name = var.network2_name
    }

    user_data = <<EOF
      #cloud-config
      hostname: "Servidor-${count.index+1}"
      manage_etc_hosts: true

      runcmd:
        - echo "<html><body><h1>Bienvenido al $(hostname)</h1></body></html>" > /var/www/html/index.html
        - systemctl start nginx
        - echo "Cloud-init completado en el $(hostname)" > /var/log/web_server-init.log
    EOF
}