# playa/nixos

===

The flake shares system settings in `configuration.nix` and command-line/Home
Manager settings in `home.nix`. Each host configuration should expect to provide
overrides and additions to these files. Machine-specific configs should also 
include a `hardware-configuration.nix` in their folder.



## Commands 

Run commands from this directory. Flakes must be enabled; add
`--extra-experimental-features 'nix-command flakes'` to `nix`, or pass `--option
experimental-features 'nix-command flakes'` to `nixos-rebuild` for the first
run.

```sh # Build without changing the running machine. nix build .#<host>

# Build & apply the configuration 
sudo nixos-rebuild switch --flake .#<host>

# Update flakes nix flake update 
```

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
