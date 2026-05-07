{
  description = "Top-level NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = 
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      mkSystem = modules:
        nixpkgs.lib.nixosSystem {
	  specialArgs.inputs = inputs;
	  inherit system; 
	  modules = [
	    # Common modules would go here.
	    # Ex. ./common.nix
	  ] ++ modules;
	};

      # Create an app to run a specific system in a VM
      # name: Which system to virtualise
      # system: The attrset holding said system. Key must match 'name.'
      mkAppVM = name: nixosConfigs: {
      	type = "app";
	program = "${nixosConfigs.${name}.config.system.build.vm}/bin/run-${name}-vm";
      };
    in
    rec {
      nixosConfigurations = 
        { archimedes = mkSystem [ ./archimedes/configuration.nix ];
	};

      # Old: archimedes = nixosConfigurations.archimedes.config.system.build.vm;
      apps = rec {
        default = archimedes;

	# `nix run .#apps.<name>`
	archimedes = mkAppVM "archimedes" nixosConfigurations;
      };

      devShells = {
	default = nixpkgs.mkShellNoCC {
	  QEMU_NET_OPTS = "hostfwd=tcp::2221-:22";
	};
      };
    };
}
