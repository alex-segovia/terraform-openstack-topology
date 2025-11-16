output "vm_admin_ip" {
  value = openstack_compute_instance_v2.admin_vm.network[0].fixed_ip_v4
}