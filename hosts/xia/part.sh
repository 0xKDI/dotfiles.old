#!/usr/bin/env bash
# I made it for convenience, you should not run it

set -e

if [ "$USER" != "root" ]; then
  echo "must be run as root"
  exit 0
fi

parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
parted /dev/nvme0n1  -- set 1 boot on
cryptsetup -y -v luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot
cryptsetup config /dev/nvme0n1p2 --label cryptroot
mkfs.ext4 -L nixos /dev/mapper/cryptroot
mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

