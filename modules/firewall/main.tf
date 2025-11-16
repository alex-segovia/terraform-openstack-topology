terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

resource "openstack_fw_rule_v2" "ssh_rule" {
  name = "firewall_ssh_rule"
  action = var.ssh_action
  protocol = "tcp"
  destination_port = "2025"
  source_ip_address = "${var.my_ip}/32"
  destination_ip_address = var.vm_admin_ip
  enabled = "true"
}

resource "openstack_fw_rule_v2" "http_rule" {
  name = "firewall_http_rule"
  action = "allow"
  protocol = "tcp"
  destination_port = "80"
  source_ip_address = "0.0.0.0/0"
  destination_ip_address = var.load_balancer_ip
  enabled = "true"
}

resource "openstack_fw_rule_v2" "internal_rule" {
  name = "firewall_internal_rule"
  action = "allow"
  protocol = "any"
  source_ip_address = "10.1.1.0/24"
  enabled = "true"
}

resource "openstack_fw_policy_v2" "ingress_policy" {
  name = "firewall_ingress_policy"

  rules = [
    openstack_fw_rule_v2.ssh_rule.id,
    openstack_fw_rule_v2.http_rule.id
  ]
}

resource "openstack_fw_policy_v2" "egress_policy" {
  name = "firewall_egress_policy"

  rules = [
    openstack_fw_rule_v2.internal_rule.id,
  ]
}

resource "openstack_fw_group_v2" "firewall_group" {
  name = "firewall_group"
  ingress_firewall_policy_id = openstack_fw_policy_v2.ingress_policy.id
  egress_firewall_policy_id = openstack_fw_policy_v2.egress_policy.id
  ports = [ var.port_id_r1 ] 
}