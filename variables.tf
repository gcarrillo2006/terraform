# ---------------------------------------------------------------------------
# Proxmox connection
# ---------------------------------------------------------------------------

variable "proxmox_api_url" {
  description = "Proxmox API endpoint, e.g. https://x.x.x.x:8006/api2/json"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID, e.g. terraform-prov@pve!terraform"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret. Pass via TF_VAR_proxmox_api_token_secret, never commit it."
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification of the Proxmox API (only for self-signed certificates)"
  type        = bool
  default     = false
}

variable "proxmox_host" {
  description = "Proxmox node the VMs are created on"
  type        = string
}

# ---------------------------------------------------------------------------
# VM template, storage and network
# ---------------------------------------------------------------------------

variable "os_template" {
  description = "Cloud-init template cloned for master, worker and storage nodes"
  type        = string
}

variable "gpu_os_template" {
  description = "Cloud-init template cloned for GPU worker nodes"
  type        = string
  default     = "ubuntu22-cloud"
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

variable "cluster_bridge_name" {
  description = "Proxmox bridge the cluster VMs attach to"
  type        = string
  default     = "vmbr0"
}

variable "vlan_tag" {
  description = "VLAN tag of the cluster network"
  type        = number
  default     = 10
}

# ---------------------------------------------------------------------------
# Node sizing
# ---------------------------------------------------------------------------

variable "master_node_instances" {
  description = "Number of control-plane nodes"
  type        = number
  default     = 1
}

variable "master_node_cpu_cores" {
  description = "CPU cores per control-plane node"
  type        = number
  default     = 2
}

variable "master_node_memory" {
  description = "Memory (MiB) per control-plane node"
  type        = number
  default     = 4096
}

variable "master_node_disk" {
  description = "Disk size per control-plane node"
  type        = string
  default     = "10G"
}

variable "worker_node_instances" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "worker_node_cpu_cores" {
  description = "CPU cores per worker node"
  type        = number
  default     = 1
}

variable "worker_node_memory" {
  description = "Memory (MiB) per worker node"
  type        = number
  default     = 2048
}

variable "worker_node_disk" {
  description = "Disk size per worker node"
  type        = string
  default     = "10G"
}

variable "worker_gpu_node_instances" {
  description = "Number of GPU worker nodes"
  type        = number
  default     = 0
}

variable "worker_gpu_node_cpu_cores" {
  description = "CPU cores per GPU worker node"
  type        = number
  default     = 1
}

variable "worker_gpu_node_memory" {
  description = "Memory (MiB) per GPU worker node"
  type        = number
  default     = 2048
}

variable "worker_gpu_node_disk" {
  description = "Disk size per GPU worker node"
  type        = string
  default     = "10G"
}

variable "worker_gpu_node_address" {
  description = "Host PCI address of the GPU passed through to each GPU worker node (one per instance)"
  type        = list(string)
  default     = []
}

variable "storage_node_instances" {
  description = "Number of storage nodes"
  type        = number
  default     = 0
}

variable "storage_node_cpu_cores" {
  description = "CPU cores per storage node"
  type        = number
  default     = 1
}

variable "storage_node_memory" {
  description = "Memory (MiB) per storage node"
  type        = number
  default     = 2048
}

variable "storage_node_disk" {
  description = "Disk size per storage node"
  type        = string
  default     = "20G"
}

variable "storage_node_disk_storage" {
  description = "Proxmox storage for storage-node disks"
  type        = string
  default     = "data-lvm"
}

# ---------------------------------------------------------------------------
# Access
# ---------------------------------------------------------------------------

variable "username" {
  description = "Cloud-init user created on every VM"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Cloud-init password for the VM user. Pass via TF_VAR_password, never commit it."
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "Operator public SSH key authorized on every VM"
  type        = string
}

variable "ssh_key_cluster" {
  description = "Additional public SSH key authorized on every VM (e.g. the Ansible control node)"
  type        = string
}

variable "k8s_proxy_hosts" {
  description = "Addresses of the API server load balancer host(s), not managed here; written to the k8s_proxy inventory group"
  type        = list(string)
  default     = []
}

variable "ssh_private_key_file" {
  description = "Private key matching ssh_key, used by provisioners and the Ansible inventory"
  type        = string
  default     = "./ssh_privkey"
}
