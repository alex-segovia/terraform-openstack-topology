variable "network_name" {
    description = "Name of the network for the VM instance"
    type = string
}

variable "subnet_name" {
    description = "Name of the subnet for the VM instance"
    type = string
}

variable "subnet_cidr" {
    description = "CIDR for the subnet for the VM instance"
    type = string
}

variable "subnet_dns_nameservers" {
    description = "DNS nameservers for the subnet for the VM instance"
    type = list(string)
}

variable "subnet_gateway_ip" {
    description = "Gateway IP for the subnet for the VM instance"
    type = string
}

variable "subnet_allocation_pool_start" {
    description = "Start IP for the Allocation pool for the subnet for the VM instance"
    type = string
}

variable "subnet_allocation_pool_end" {
    description = "End IP for the Allocation pool for the subnet for the VM instance"
    type = string
}