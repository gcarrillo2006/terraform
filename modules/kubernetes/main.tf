locals {
  sshkeys = join("\n", [var.ssh_key, var.ssh_key_cluster])

  # Runs on the Alma (dnf) nodes once they are reachable over SSH.
  bootstrap_commands = [
    "sudo dnf install -y ansible-core",
  ]
}

# ---------------------------------------------------------------------------
# Control-plane nodes: kube-server-NN, VMID 30N
# ---------------------------------------------------------------------------
resource "proxmox_vm_qemu" "kube_server" {
  count       = var.master_node_instances
  name        = format("kube-server-%02d", count.index + 1)
  target_node = var.proxmox_host
  vmid        = 301 + count.index
  clone       = var.os_template
  agent       = 1
  os_type     = var.os_type
  machine     = "q35"
  onboot      = true
  memory      = var.master_node_memory
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  ciuser      = var.username
  cipassword  = var.password
  ciupgrade   = true
  ipconfig0   = "ip=dhcp"
  sshkeys     = local.sshkeys

  cpu {
    cores   = var.master_node_cpu_cores
    sockets = 1
    type    = "host"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.disk_storage
          size     = var.master_node_disk
          iothread = true
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  network {
    id       = 0
    model    = var.network_model
    bridge   = var.cluster_bridge_name
    firewall = true
    tag      = var.vlan_tag
  }

  lifecycle {
    ignore_changes = [network]
  }

  provisioner "remote-exec" {
    inline = local.bootstrap_commands

    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = var.username
      private_key = file(var.ssh_private_key_file)
    }
  }
}

# ---------------------------------------------------------------------------
# Worker nodes: kube-agent-NN, VMID 40N
# ---------------------------------------------------------------------------
resource "proxmox_vm_qemu" "kube_agent" {
  count       = var.worker_node_instances
  name        = format("kube-agent-%02d", count.index + 1)
  target_node = var.proxmox_host
  vmid        = 401 + count.index
  clone       = var.os_template
  agent       = 1
  os_type     = var.os_type
  machine     = "q35"
  onboot      = true
  memory      = var.worker_node_memory
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  ciuser      = var.username
  cipassword  = var.password
  ciupgrade   = true
  ipconfig0   = "ip=dhcp"
  sshkeys     = local.sshkeys

  cpu {
    cores   = var.worker_node_cpu_cores
    sockets = 1
    type    = "host"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.disk_storage
          size     = var.worker_node_disk
          iothread = true
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  network {
    id       = 0
    model    = var.network_model
    bridge   = var.cluster_bridge_name
    firewall = true
    tag      = var.vlan_tag
  }

  lifecycle {
    ignore_changes = [network]
  }

  provisioner "remote-exec" {
    inline = local.bootstrap_commands

    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = var.username
      private_key = file(var.ssh_private_key_file)
    }
  }
}

# ---------------------------------------------------------------------------
# GPU worker nodes: kube-agent-gpu-NN, VMID 50N
#
# Ubuntu + OVMF with the GPU passed through over PCIe. User data comes from a
# custom snippet (see cloud-init-ubuntu.yaml) that must exist on the Proxmox
# host as <snippets_storage>:snippets/user_data_vm-<VMID>.yml before apply.
# ---------------------------------------------------------------------------
resource "proxmox_vm_qemu" "kube_agent_gpu" {
  count       = var.worker_gpu_node_instances
  name        = format("kube-agent-gpu-%02d", count.index + 1)
  target_node = var.proxmox_host
  vmid        = 501 + count.index
  clone       = var.gpu_os_template
  agent       = 1
  os_type     = var.os_type
  bios        = "ovmf"
  machine     = "q35"
  onboot      = true
  memory      = var.worker_gpu_node_memory
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  ciuser      = var.username
  cipassword  = var.password
  cicustom    = "user=${var.snippets_storage}:snippets/user_data_vm-${501 + count.index}.yml"
  ciupgrade   = true
  ipconfig0   = "ip=dhcp"
  sshkeys     = local.sshkeys

  cpu {
    cores   = var.worker_gpu_node_cpu_cores
    sockets = 1
    type    = "host"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.disk_storage
          size     = var.worker_gpu_node_disk
          iothread = true
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  hostpci {
    host   = var.worker_gpu_node_address[count.index]
    rombar = 1
    pcie   = 1
  }

  network {
    id       = 0
    model    = var.network_model
    bridge   = var.cluster_bridge_name
    firewall = true
    tag      = var.vlan_tag
  }

  lifecycle {
    ignore_changes = [network]
  }
}

# ---------------------------------------------------------------------------
# Storage nodes: kube-storage-NN, VMID 60N
# ---------------------------------------------------------------------------
resource "proxmox_vm_qemu" "kube_storage" {
  count       = var.storage_node_instances
  name        = format("kube-storage-%02d", count.index + 1)
  target_node = var.proxmox_host
  vmid        = 601 + count.index
  clone       = var.os_template
  agent       = 1
  os_type     = var.os_type
  machine     = "q35"
  onboot      = true
  memory      = var.storage_node_memory
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  ciuser      = var.username
  cipassword  = var.password
  ciupgrade   = true
  ipconfig0   = "ip=dhcp"
  sshkeys     = local.sshkeys

  cpu {
    cores   = var.storage_node_cpu_cores
    sockets = 1
    type    = "host"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.storage_node_disk_storage
          size     = var.storage_node_disk
          iothread = true
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  network {
    id       = 0
    model    = var.network_model
    bridge   = var.cluster_bridge_name
    firewall = true
    tag      = var.vlan_tag
  }

  lifecycle {
    ignore_changes = [network]
  }

  provisioner "remote-exec" {
    inline = local.bootstrap_commands

    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = var.username
      private_key = file(var.ssh_private_key_file)
    }
  }
}
