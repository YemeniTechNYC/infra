resource "digitalocean_droplet" "www" {
    count              = var.node_count
    image              = var.web_image_id
    ipv6               = true
    monitoring         = true
    name               = format("www-%.2d", count.index)
    vpc_uuid           = digitalocean_vpc.www-vpc.id
    region             = var.region
    size               = var.size
    tags               = ["www"]
    ssh_keys           = [
      data.digitalocean_ssh_key.terraform.id
    ]
}

resource "digitalocean_firewall" "www" {
    droplet_ids = digitalocean_droplet.www[*].id
    name = "www-firewall"

    inbound_rule {
        protocol           = "tcp"
        port_range         = "22"
        source_tags = ["jumpserver"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "80"
        source_tags           = ["jenkins"]
        source_load_balancer_uids = [digitalocean_loadbalancer.www-lb.id]
    }

    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol              = "udp"
        port_range            = "514"
        destination_tags      = ["logserver"]
    }
}


resource "digitalocean_certificate" "website" {
  name    = "website"
  type    = "lets_encrypt"
  domains = ["yemenisintech.org"]
}

resource "digitalocean_loadbalancer" "www-lb" {
    name                   = "website"
    region                 = var.region
    droplet_tag            = "www"
    redirect_http_to_https = true
    vpc_uuid           = digitalocean_vpc.www-vpc.id

    forwarding_rule {
        entry_port      = 80
        entry_protocol  = "http"

        target_port     = 80
        target_protocol = "http"
    }

    forwarding_rule {
        entry_port      = 443
        entry_protocol  = "https"

        target_port     = 80
        target_protocol = "http"

        certificate_name  = digitalocean_certificate.website.name
    }

    healthcheck {
        port            = 80
        protocol        = "http"
        path            = "/health"
    }
}

output "www_ips" {
    value = digitalocean_droplet.www[*].ipv4_address_private
}
