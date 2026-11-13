output "master_nodes_ssh_host" {
  description = "IP addresses of the control-plane nodes"
  value       = proxmox_vm_qemu.kube_server[*].ssh_host
}

output "worker_nodes_ssh_host" {
  description = "IP addresses of the worker nodes"
  value       = proxmox_vm_qemu.kube_agent[*].ssh_host
}

output "worker_gpu_nodes_ssh_host" {
  description = "IP addresses of the GPU worker nodes"
  value       = proxmox_vm_qemu.kube_agent_gpu[*].ssh_host
}

output "storage_nodes_ssh_host" {
  description = "IP addresses of the storage nodes"
  value       = proxmox_vm_qemu.kube_storage[*].ssh_host
}
