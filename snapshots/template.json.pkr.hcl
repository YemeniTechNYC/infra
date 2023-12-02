# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# See https://www.packer.io/docs/templates/hcl_templates/blocks/packer for more info
packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
variable "ansible_secret_path" {
  type    = string
  default = "${env("ANSIBLE_SECRET_PATH")}"
}

variable "do_token" {
  type    = string
  default = "${env("DO_PAT")}"
}

variable "service" {
  type    = string
  default = "${env("SERVICE")}"
}

variable "source_snapshot" {
  type    = string
  default = "${env("SOURCE_SNAPSHOT")}"
}

variable "ansible_inventory_group" {
  type    = string
  default = "${env("ANSIBLE_INVENTORY_HOST_GROUP")}"
}

variable "ansible_playbook" {
  type    = string
  default = "${env("ANSIBLE_PLAYBOOK")}"
}

variable "version" {
  type    = string
  default = "${env("SERVICE_VERSION")}"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# All locals variables are generated from variables that uses expressions
# that are not allowed in HCL2 variables.
# Read the documentation for locals blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/locals
locals {
  snapshot_name = "${var.service}-${var.version}"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "digitalocean" "source" {
  api_token        = "${var.do_token}"
  image            = "${var.source_snapshot}"
  region           = "nyc1"
  size             = "s-2vcpu-4gb"
  snapshot_name    = "${local.snapshot_name}"
  snapshot_regions = ["nyc1"]
  ssh_username     = "root"
  tags             = ["${var.service}"]
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.digitalocean.source"]

  provisioner "ansible" {
    extra_arguments = ["--vault-password-file=${var.ansible_secret_path}", "--scp-extra-args", "'-O'"]
    groups          = ["${var.ansible_inventory_group}"]
    playbook_file   = "${var.ansible_playbook}"
  }

  post-processor "manifest" {
    custom_data = {
      service       = "${var.service}"
      snapshot_name = "${local.snapshot_name}"
    }
    output     = "packer-manifest.json"
    strip_path = true
  }
}
