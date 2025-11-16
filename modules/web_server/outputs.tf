output "web_server_ips" {
  value = { for name, inst in openstack_compute_instance_v2.web_server: name => inst.access_ip_v4 } 
}