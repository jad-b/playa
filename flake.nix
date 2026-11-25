{
  description = "NixOS configurations for the jdb laptop lineage";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }:
    let
      # Define a lambda to easily append host-specific modules 
      mkHost = modules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Common to all hosts
          home-manager.nixosModules.home-manager
          {
	    home-manager.backupFileExtension = "bak";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jdb = import ./home.nix;
          }
        ] ++ modules;
      };
    in {
      packages.x86_64-linux.wsl-nixos =
        self.nixosConfigurations.wsl-nixos.config.system.build.toplevel;

      nixosConfigurations = {
        locke = mkHost [ ./locke/configuration.nix ];
        wsl-nixos = mkHost [
          nixos-wsl.nixosModules.default
          ./wsl-nixos/configuration.nix
        ];
	locke-iso = mkHost [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          # Provide an initial copy of the NixOS channel so that the user
          # doesn't need to run "nix-channel --update" first.
	  # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          ({ pkgs, modulesPath, ... }: {
            isoImage.squashfsCompression = "zstd";
            boot.zfs.forceImportRoot = false;
          })
          ./locke/configuration.nix
        ];
      };
    };
}
