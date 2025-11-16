terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name = var.loadbalancer_name
  vip_subnet_id = var.subnet_id
}

resource "openstack_lb_listener_v2" "listener" {
  name = var.listener_name
  protocol = var.protocol
  protocol_port = var.port
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "pool" {
  name = var.pool_name
  protocol = var.protocol
  lb_method = var.loadbalancer_method
  listener_id = openstack_lb_listener_v2.listener.id
}

resource "openstack_lb_member_v2" "loadbalancer_member" {
  for_each      = var.web_server_ips
  address       = each.value
  protocol_port = var.port
  pool_id       = openstack_lb_pool_v2.pool.id
  subnet_id     = var.subnet_id
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool = "ExtNet"
}

resource "openstack_networking_floatingip_associate_v2" "lb_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.lb_fip.address
  port_id = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}