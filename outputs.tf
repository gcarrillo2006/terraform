output "master_nodes" {
  description = "IP addresses of the control-plane nodes"
  value       = module.kubernetes.master_nodes_ssh_host
}

output "worker_nodes" {
  description = "IP addresses of the worker nodes"
  value       = module.kubernetes.worker_nodes_ssh_host
}

output "worker_gpu_nodes" {
  description = "IP addresses of the GPU worker nodes"
  value       = module.kubernetes.worker_gpu_nodes_ssh_host
}

output "storage_nodes" {
  description = "IP addresses of the storage nodes"
  value       = module.kubernetes.storage_nodes_ssh_host
}
