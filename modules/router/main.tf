terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_networking_router_v2" "router" {
  name = var.router_name
  external_network_id = var.external_network_id
}

resource "openstack_networking_port_v2" "port" {
  name = var.port_name
  network_id = var.network_id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = var.subnet_id
    ip_address = var.subnet_gateway_ip
  }
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  port_id = openstack_networking_port_v2.port.id
}