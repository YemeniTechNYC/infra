variable "size" {
  description = "Size of Droplet"
  default     = "s-1vcpu-1gb"
}

variable "region" {
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}

variable "node_count" {
    description = "Node count"
    default     = "1"
}

variable "release" {
  description = "release version"
  default     = "0.1.0-dev"
}

variable "jumpserver_image_id" {
    description = "snapshot id of jumpserver"
    default = "fedora-38-x64"
}

variable "web_image_id" {
    description = "snapshot id of web"
    default = "fedora-38-x64"
}
