# terraform

OpenTofu / Terraform configuration that provisions the VMs for a bare-metal
Kubernetes cluster on Proxmox VE, and writes an Ansible inventory for the
[ansible](../ansible) repo.

| Node type | Name | VMID | Template |
|-----------|------|------|----------|
| Control plane | `kube-server-NN` | 301+ | `os_template` |
| Worker | `kube-agent-NN` | 401+ | `os_template` |
| GPU worker (PCIe passthrough) | `kube-agent-gpu-NN` | 501+ | `gpu_os_template` |
| Storage | `kube-storage-NN` | 601+ | `os_template` |

## Requirements

- [OpenTofu](https://opentofu.org) >= 1.6 (`brew install opentofu`) or Terraform >= 1.6
- A Proxmox VE API token for the provider
- Cloud-init VM templates named as in `os_template` / `gpu_os_template`
- For GPU nodes: IOMMU enabled on the host, and a user-data snippet per GPU VM
  created from [`modules/kubernetes/cloud-init-ubuntu.yaml`](modules/kubernetes/cloud-init-ubuntu.yaml)

## Usage

```sh
# 1. SSH key used by the provisioners and Ansible (written to ./ssh_privkey)
./create_keyfiles.sh

# 2. Environment settings - set ssh_key to the contents of ./ssh_privkey.pub
cp terraform.tfvars.example terraform.tfvars

# 3. Secrets, kept out of files
export TF_VAR_proxmox_api_token_secret='<token-secret>'
export TF_VAR_password='<vm-user-password>'

# 4. Deploy
tofu init
tofu plan -out=tfplan
tofu apply tfplan
```

After apply, `./inventory` contains the node IPs grouped as `k8s_master`,
`k8s_worker`, `k8s_worker_gpu` and `k8s_storage`.

## Secrets

Nothing sensitive is committed. `terraform.tfvars`, state files, the generated
inventory and SSH keys are git-ignored; the Proxmox token secret and VM
password are passed as `TF_VAR_*` environment variables.
