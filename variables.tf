variable "server_count" {
  type = number
  default = 3
}

variable "ssh_action" {
  type = string
  default = "allow"
}

variable "my_ip" {
  type = string
  default = "10.0.10.1"
}