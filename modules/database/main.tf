terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_compute_instance_v2" "database_vm" {
    name = var.name
    flavor_name = var.flavor
    image_name = var.image
    security_groups = var.security_groups
    network{
        name = var.network2_name
    }

    user_data = <<EOF
      #cloud-config
      hostname: "BBDD"
      manage_etc_hosts: true

      runcmd:
        - systemctl start mariadb
        - sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
        - systemctl restart mariadb
        - mysql -e "CREATE DATABASE cnvr_bbdd;"
        - mysql -e "CREATE USER 'web_server'@'%' IDENTIFIED BY 'xxxx';"
        - mysql -e "GRANT ALL PRIVILEGES ON cnvr_bbdd.* TO 'web_server'@'%';"
        - mysql -e "FLUSH PRIVILEGES;"
        - echo "Cloud-init completado en la base de datos" > /var/log/bbdd-init.log
    EOF
}