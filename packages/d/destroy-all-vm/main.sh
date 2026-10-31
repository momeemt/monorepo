# shellcheck disable=SC2148

set -euo pipefail

remove_vm() {
  sudo virsh -c qemu://// destroy "$1" || true
  sudo rm -f "/var/lib/libvirt/images/$1.qcow2"
}

# emu
remove_vm kube-master
remove_vm kube-worker-emu-1
remove_vm kube-worker-emu-2

# shime
remove_vm kube-worker-shime-1
