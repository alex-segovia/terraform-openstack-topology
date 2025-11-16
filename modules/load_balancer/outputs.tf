output "load_balancer_ip" {
  value = openstack_lb_loadbalancer_v2.loadbalancer.vip_address
}