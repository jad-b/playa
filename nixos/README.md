# playa/nixos

===

The flake shares system settings in `configuration.nix` and command-line/Home
Manager settings in `home.nix`. 


## Commands 

All commands should be run from this directory. 

### Per-host setup 

Flakes must be enabled: 
add `--extra-experimental-features 'nix-command flakes'` to `nix`, 
or pass `--option experimental-features 'nix-command flakes'` 
to `nixos-rebuild` for the first run.

#### Rescan the hardware configuration

Important to do if the disk/filesystem setup changes, such as enabling LUKS.

```sh
sudo nixos-generate-config --show-hardware-config > <host>/hardware-configuration.nix
```

### Development and testing

```sh
# Build without changing the running machine. 
nix build .#<host>

# Build & apply the configuration 
sudo nixos-rebuild switch --flake .#<host>

# Update flakes 
nix flake update 
```

### ISO Generation 
Generate: 

```sh
nix build .#nixosConfigurations.locke-iso.config.system.build.isoImage
```

Test in a VM:

```sh
nix-shell -p qemu && \
  qemu-system-x86_64 -enable-kvm -m 4G -cdrom result/iso/nixos-*.iso
```

Write to a USB:
```sh
# Find your USB drive
lsblk | grep '/media'

# Unmount it
sudo umount /dev/sdX*

# Write the ISO to it
sudo dd \
    bs=4M conv=fsync oflag=direct status=progress \
    if=$(ls -t result/iso/nixos-*.iso | head -n 1) \
    of=/dev/sda                                      # typically sda
```

[Creating a live NixOS live CD](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
|[Creating bootable USB flash drive from a Terminal on Linux](https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-linux)

### WSL-specific considerations 

This machine's `/etc/nixos` points to that checkout's `nixos` directory; the
initial configuration is preserved in `/etc/nixos.before-playa`. The hostname
matches the flake output, so `sudo nixos-rebuild switch` also selects this
target.

#### PowerShell-level interactions

After the first WSL activation, restart that distribution from PowerShell:

```powershell 
wsl --terminate NixOS wsl -d NixOS 
```

To recover the previous system generation from PowerShell:

```powershell 
wsl -d NixOS -u root -- sh -lc 'nixos-rebuild switch --rollback'
wsl --terminate NixOS 
```

Initialize the account's password:

```powershell 
wsl -d NixOS -u root -- sh -lc 'passwd jdb' 
```

The local checkout can use Windows OpenSSH and the existing Windows key through
repository-local `core.sshCommand`; credentials are not included in this flake
or copied into the Nix store. Other machines should configure their own Git SSH
access.
