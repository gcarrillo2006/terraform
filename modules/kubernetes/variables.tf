variable "proxmox_host" {
  description = "Proxmox node the VMs are created on"
  type        = string
}

variable "os_template" {
  description = "Cloud-init template cloned for master, worker and storage nodes"
  type        = string
}

variable "gpu_os_template" {
  description = "Cloud-init template cloned for GPU worker nodes"
  type        = string
}

variable "os_type" {
  description = "Proxmox OS type used for provisioning"
  type        = string
  default     = "cloud-init"
}

variable "disk_storage" {
  description = "Proxmox storage for VM boot and cloud-init disks"
  type        = string
  default     = "local-lvm"
}

variable "snippets_storage" {
  description = "Proxmox storage holding cloud-init snippets (GPU nodes)"
  type        = string
  default     = "local"
}

variable "network_model" {
  description = "NIC model"
  type        = string
  default     = "virtio"
}

variable "cluster_bridge_name" {
  description = "Proxmox bridge the cluster VMs attach to"
  type        = string
}

variable "vlan_tag" {
  description = "VLAN tag of the cluster network"
  type        = number
}

variable "master_node_instances" {
  description = "Number of control-plane nodes"
  type        = number
}

variable "master_node_cpu_cores" {
  description = "CPU cores per control-plane node"
  type        = number
}

variable "master_node_memory" {
  description = "Memory (MiB) per control-plane node"
  type        = number
}

variable "master_node_disk" {
  description = "Disk size per control-plane node"
  type        = string
}

variable "worker_node_instances" {
  description = "Number of worker nodes"
  type        = number
}

variable "worker_node_cpu_cores" {
  description = "CPU cores per worker node"
  type        = number
}

variable "worker_node_memory" {
  description = "Memory (MiB) per worker node"
  type        = number
}

variable "worker_node_disk" {
  description = "Disk size per worker node"
  type        = string
}

variable "worker_gpu_node_instances" {
  description = "Number of GPU worker nodes"
  type        = number
}

variable "worker_gpu_node_cpu_cores" {
  description = "CPU cores per GPU worker node"
  type        = number
}

variable "worker_gpu_node_memory" {
  description = "Memory (MiB) per GPU worker node"
  type        = number
}

variable "worker_gpu_node_disk" {
  description = "Disk size per GPU worker node"
  type        = string
}

variable "worker_gpu_node_address" {
  description = "Host PCI address of the GPU passed through to each GPU worker node (one per instance)"
  type        = list(string)

  validation {
    condition     = length(var.worker_gpu_node_address) >= var.worker_gpu_node_instances
    error_message = "worker_gpu_node_address needs one PCI address per GPU worker node."
  }
}

variable "storage_node_instances" {
  description = "Number of storage nodes"
  type        = number
}

variable "storage_node_cpu_cores" {
  description = "CPU cores per storage node"
  type        = number
}

variable "storage_node_memory" {
  description = "Memory (MiB) per storage node"
  type        = number
}

variable "storage_node_disk" {
  description = "Disk size per storage node"
  type        = string
}

variable "storage_node_disk_storage" {
  description = "Proxmox storage for storage-node disks"
  type        = string
}

variable "username" {
  description = "Cloud-init user created on every VM"
  type        = string
}

variable "password" {
  description = "Cloud-init password for the VM user"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "Operator public SSH key authorized on every VM"
  type        = string
}

variable "ssh_key_cluster" {
  description = "Additional public SSH key authorized on every VM"
  type        = string
}

variable "ssh_private_key_file" {
  description = "Private key matching ssh_key, used by the provisioners"
  type        = string
}
