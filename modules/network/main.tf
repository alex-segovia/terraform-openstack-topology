terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_networking_network_v2" "net" {
  name = var.network_name
}

resource "openstack_networking_subnet_v2" "subnet"{
    name = var.subnet_name
    network_id = openstack_networking_network_v2.net.id
    cidr = var.subnet_cidr
    ip_version = 4
    dns_nameservers = var.subnet_dns_nameservers
    gateway_ip = var.subnet_gateway_ip
    allocation_pool{
        start = var.subnet_allocation_pool_start
        end = var.subnet_allocation_pool_end
    }  
}