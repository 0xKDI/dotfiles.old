# Installation

Configure the wifi
```sh
wpa_supplicant -B -i interface_name -c <(wpa_passphrase 'SSID' 'key')
```

Partition the disks
```sh
hardware/part.sh
```

Add channels
```sh
nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixos 
nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager 
nix-channel --add "https://github.com/nix-community/NUR/archive/master.tar.gz" nur

```

Install nixos
```sh
nixos-install --root /mnt
```
