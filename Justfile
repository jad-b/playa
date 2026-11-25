# List all the just commands
default:
    @just --list

# Rebuild and switch the active configuration
rebuild host:
  sudo nixos-rebuild switch --flake $".#{{host}}"


