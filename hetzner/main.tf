terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.38.2"
    }
  }

  backend "s3" {
    bucket = var.tf_state_bucket
    key    = "hetzner/infra.tfstate"
    region = "us-west-1"
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "axion-ssh" {
  name       = "Axion SSH Key"
  public_key = file("../ssh/id_ed25519.pub")
}

resource "hcloud_server" "axion" {
  name              = var.server_name
  location          = var.server_location
  image             = var.server_image
  server_type       = var.server_type
  backups           = true
  delete_protection = false
  ssh_keys          = [hcloud_ssh_key.axion-ssh.id]
  user_data = templatefile("../cloud-init/cloud-init.tftpl", {
    tailscale_key = var.tailscale_key
  })

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  labels = {
    name = var.server_name
  }
}
