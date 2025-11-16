terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_networking_secgroup_v2" "my_security_group" {
 name = "open"
 description = "Grupo de Seguridad para permitir todo el trafico"
 delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ingress" {
 direction = "ingress"
 ethertype = "IPv4"
 protocol = "tcp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_egress" {
 direction = "egress"
 ethertype = "IPv4"
 protocol = "tcp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_icmp" {
 direction = "ingress"
 ethertype = "IPv4"
 protocol = "icmp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_egress_icmp" {
 direction = "egress"
 ethertype = "IPv4"
 protocol = "icmp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}