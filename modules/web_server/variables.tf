variable "server_count" {
    description = "Count of VM instances"
    type = number
}

variable "flavor"{
    description = "Flavor of the VM instance"
    type = string
} 

variable "image"{
    description = "Image of the VM instance"
    type = string
}

variable "security_groups" {
    description = "List of security groups for the VM instance"
    type = list(string)
}

variable "network1_name" {
    description = "Name of the network 1 for the VM instance"
    type = string
}

variable "network2_name" {
    description = "Name of the network 2 for the VM instance"
    type = string
}