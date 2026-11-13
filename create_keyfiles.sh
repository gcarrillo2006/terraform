#!/bin/sh
# Generate the SSH key pair used to provision the VMs and run Ansible.
#   ./ssh_privkey      private key (git-ignored, never commit it)
#   ./ssh_privkey.pub  public key, paste into ssh_key in terraform.tfvars
set -eu

KEY=./ssh_privkey

if [ -e "$KEY" ]; then
  echo "$KEY already exists, not overwriting" >&2
  exit 1
fi

ssh-keygen -t ed25519 -N "" -C "terraform-provisioner" -f "$KEY"
chmod 600 "$KEY"
echo "Public key:"
cat "$KEY.pub"
