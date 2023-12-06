resource "digitalocean_vpc" "www-vpc" {
  name   = "www-vpc"
  region = var.region
}

resource "digitalocean_droplet" "jumpserver" {
    image              = var.jumpserver_image_id
    ipv6               = true
    monitoring         = true
    name               = "jumpserver"
    vpc_uuid           = digitalocean_vpc.www-vpc.id
    region             = var.region
    size               = var.size
    tags               = ["jumpserver", "jenkins", "logserver"]
    ssh_keys           = [
      data.digitalocean_ssh_key.terraform.id
    ]
}

output "jumpserver_ips" {
    value = digitalocean_droplet.jumpserver.ipv4_address
}

resource "digitalocean_record" "logs" {
  domain = "yemenisintech.org"
  type   = "A"
  name   = "logs"
  value  = digitalocean_droplet.jumpserver.ipv4_address
}

resource "digitalocean_firewall" "jumpserver" {
    droplet_ids = [digitalocean_droplet.jumpserver.id]
    name = "jumpserver-firewall"

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "udp"
        port_range       = "514"
        source_tags = ["www"]
    }

    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}
