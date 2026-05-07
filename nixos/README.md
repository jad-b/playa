# playa/nixos
---

## commands.
Test the as a VM

        nix build .#archimedes
        # nix build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-24.05 -I nixos-config=./archimedes/configuration.nix

## resources.
- [gist](https://gist.github.com/FlakM/0535b8aa7efec56906c5ab5e32580adf?permalink_comment_id=5167381#gistcomment-5167381) showing easier VM definitions in your flake
