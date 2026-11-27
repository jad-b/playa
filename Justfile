# List all the just commands
list:
    @just --list

build host:
  nix build $".#{{host}}.config.system.build.toplevel" --no-link --print-build-logs

# Rebuild and switch the active configuration
rebuild host:
  sudo nixos-rebuild switch --flake $".#{{host}}"

update:
  nix flake update

regenerate-config host:
  sudo nixos-generate-config --show-hardware-config > $"{{host}}/hardware-configuration.nix"

########################################
# ISO Generation
########################################
# - [Creating a live NixOS live CD](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
# - [Creating bootable USB flash drive from a Terminal on Linux](https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-linux)
[group('iso')]
generate:
  nix build .#nixosConfigurations.locke-iso.config.system.build.isoImage

[group('iso')]
test-vm:
  nix-shell -p qemu && \
    qemu-system-x86_64 -enable-kvm -m 4G -cdrom (ls -t result/iso/nixos-*.iso | head -n 1)

[group('iso')]
flash-iso disk:
  sudo umount $"/dev/{{disk}}"
  sudo dd \
    bs=4M conv=fsync oflag=direct status=progress \
    if=(ls -t result/iso/nixos-*.iso | head -n 1) \
    of=$"/dev/{{disk}}"
