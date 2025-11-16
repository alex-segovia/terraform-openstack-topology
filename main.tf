terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
    user_name = "admin"
    tenant_name = "admin"
    password = "xxxx"
    user_domain_name = "Default"
    project_domain_name = "Default"
    auth_url = "http://controller:5000/v3"
    region = "RegionOne"
}

// Creación de la máquina ADMIN

module "vm_admin" {
    source = "./modules/vm_admin"
    name = "ADMIN"
    flavor = "m1.smaller"
    image = "jammy-server-cloudimg-amd64-vnx"
    key_pair = "admin"
    security_groups = [ module.security_group_open.security_group_name ]
    network1_name = module.net1.network_name
    network2_name = module.net2.network_name

    depends_on = [ module.net1, module.net2, module.security_group_open ]
}

// Creación de los servidores web

module "web_servers" {
    source = "./modules/web_server"
    server_count = var.server_count
    flavor = "m1.smaller"
    image = module.web_server_image.image_name
    security_groups = [ module.security_group_open.security_group_name ]
    network1_name = module.net1.network_name
    network2_name = module.net2.network_name

    depends_on = [ module.net1, module.net2, module.security_group_open, module.web_server_image ]
}

// Creación de las redes

module "net1" {
    source = "./modules/network"
    network_name = "Net1"
    subnet_name = "Subnet1"
    subnet_cidr = "10.1.1.0/24"
    subnet_gateway_ip = "10.1.1.1"
    subnet_dns_nameservers = [ "8.8.8.8" ]
    subnet_allocation_pool_start = "10.1.1.2"
    subnet_allocation_pool_end = "10.1.1.100"
}

module "net2" {
    source = "./modules/network"
    network_name = "Net2"
    subnet_name = "Subnet2"
    subnet_cidr = "10.1.2.0/24"
    subnet_gateway_ip = "10.1.2.1"
    subnet_dns_nameservers = [ "8.8.8.8" ]
    subnet_allocation_pool_start = "10.1.2.2"
    subnet_allocation_pool_end = "10.1.2.100"
}

// Creación del router

data "openstack_networking_network_v2" "ExtNet" {
    name = "ExtNet"
} 

module "r1" {
    source = "./modules/router"
    router_name = "R1"
    external_network_id = data.openstack_networking_network_v2.ExtNet.id
    port_name = "port"
    network_id = module.net1.network_id
    subnet_id = module.net1.subnet_id
    subnet_gateway_ip = module.net1.subnet_gateway_ip

    depends_on = [ module.net1 ]
}

// Creación del servidor de base de datos

module "vm_database" {
    source = "./modules/database"
    name = "BBDD"
    flavor = "m1.smaller"
    image = module.database_server_image.image_name
    security_groups = [ module.security_group_open.security_group_name ]
    network2_name = module.net2.network_name

    depends_on = [ module.net2, module.security_group_open, module.database_server_image ]
}

// Creación del servidor de almacenamiento de ficheros/objectos

module "vm_storage" {
    source = "./modules/storage"
    name = "Storage"
    flavor = "m1.smaller"
    image = "jammy-server-cloudimg-amd64-vnx"
    security_groups = [ module.security_group_open.security_group_name ]
    network2_name = module.net2.network_name
    volume_name = "storage_volume"
    volume_size = 10

    depends_on = [ module.net2, module.security_group_open ]
}

// Creación del balanceador de carga

module "load_balancer" {
    source = "./modules/load_balancer"
    loadbalancer_name = "elastic_loadbalancer_web_servers"
    subnet_id = module.net1.subnet_id
    listener_name = "listener_web_servers"
    protocol = "TCP"
    port = 80
    pool_name = "pool_web_servers"
    loadbalancer_method = "ROUND_ROBIN"
    web_server_ips = module.web_servers.web_server_ips

    depends_on = [ module.net1, module.web_servers ]
}

// Creación del Security Group "open"

module "security_group_open"{
    source = "./modules/security_group"
}

// Creación del Firewall

module "firewall"{
    source = "./modules/firewall"
    vm_admin_ip = module.vm_admin.vm_admin_ip
    load_balancer_ip = module.load_balancer.load_balancer_ip
    port_id_r1 = module.r1.port_id
    ssh_action = var.ssh_action
    my_ip = var.my_ip

    depends_on = [ module.load_balancer, module.vm_admin, module.r1 ]
}

// Creación de las imágenes

module "web_server_image" {
    source = "./modules/image"
    image_name = "web_server_image"
    image_file_name = "web_server_image.qcow2"
    container_format = "bare"
    disk_format = "qcow2"
    visibility = "public"
}

module "database_server_image" {
    source = "./modules/image"
    image_name = "database_server_image"
    image_file_name = "database_server_image.qcow2"
    container_format = "bare"
    disk_format = "qcow2"
    visibility = "public"
}
