output "network_name" {
  value = openstack_networking_network_v2.net.name
}

output "network_id" {
  value = openstack_networking_network_v2.net.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.subnet.id
}

output "subnet_gateway_ip" {
  value = openstack_networking_subnet_v2.subnet.gateway_ip
}