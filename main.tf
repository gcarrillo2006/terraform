provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}

module "kubernetes" {
  source = "./modules/kubernetes"

  proxmox_host        = var.proxmox_host
  os_template         = var.os_template
  gpu_os_template     = var.gpu_os_template
  os_type             = var.os_type
  disk_storage        = var.disk_storage
  snippets_storage    = var.snippets_storage
  cluster_bridge_name = var.cluster_bridge_name
  vlan_tag            = var.vlan_tag

  master_node_instances = var.master_node_instances
  master_node_cpu_cores = var.master_node_cpu_cores
  master_node_memory    = var.master_node_memory
  master_node_disk      = var.master_node_disk

  worker_node_instances = var.worker_node_instances
  worker_node_cpu_cores = var.worker_node_cpu_cores
  worker_node_memory    = var.worker_node_memory
  worker_node_disk      = var.worker_node_disk

  worker_gpu_node_instances = var.worker_gpu_node_instances
  worker_gpu_node_cpu_cores = var.worker_gpu_node_cpu_cores
  worker_gpu_node_memory    = var.worker_gpu_node_memory
  worker_gpu_node_disk      = var.worker_gpu_node_disk
  worker_gpu_node_address   = var.worker_gpu_node_address

  storage_node_instances    = var.storage_node_instances
  storage_node_cpu_cores    = var.storage_node_cpu_cores
  storage_node_memory       = var.storage_node_memory
  storage_node_disk         = var.storage_node_disk
  storage_node_disk_storage = var.storage_node_disk_storage

  username             = var.username
  password             = var.password
  ssh_key              = var.ssh_key
  ssh_key_cluster      = var.ssh_key_cluster
  ssh_private_key_file = var.ssh_private_key_file
}

# Ansible inventory for the ansible repo, written once the VMs are up.
resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/inventory"
  file_permission = "0644"
  content = templatefile("${path.root}/inventory.tmpl", {
    k8s_proxy            = var.k8s_proxy_hosts
    k8s_master           = module.kubernetes.master_nodes_ssh_host
    k8s_worker           = module.kubernetes.worker_nodes_ssh_host
    k8s_worker_gpu       = module.kubernetes.worker_gpu_nodes_ssh_host
    k8s_storage          = module.kubernetes.storage_nodes_ssh_host
    ansible_user         = var.username
    ssh_private_key_file = var.ssh_private_key_file
  })
}
