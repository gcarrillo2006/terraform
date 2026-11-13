terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
