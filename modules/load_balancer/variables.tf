variable "loadbalancer_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "listener_name" {
  type = string
}

variable "protocol" {
  type = string
}

variable "port" {
  type = number
}

variable "pool_name" {
  type = string
}

variable "loadbalancer_method" {
  type = string
}

variable "web_server_ips" {
  type = map(string)
}