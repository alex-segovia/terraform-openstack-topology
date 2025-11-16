output "security_group_name" {
  value = openstack_networking_secgroup_v2.my_security_group.name
}