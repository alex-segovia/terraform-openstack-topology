variable "name" {
    description = "Name of VM instance"
    type = string
}

variable "flavor"{
    description = "Flavor of the VM instance"
    type = string
} 

variable "image"{
    description = "Image of the VM instance"
    type = string
} 

variable "key_pair"{
    description = "Key pair for the VM instace"
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