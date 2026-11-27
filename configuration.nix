# Settings shared by every host built from this flake.
{ lib, pkgs, ... }:
{
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.groups.jdb = { };
  users.users.jdb = {
    isNormalUser = true;
    description = "jdb";
    extraGroups = [ "jdb" "wheel" ];
  };

  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [ git jq neovim wget ];
  environment.variables.EDITOR = "nvim";

  # Hosts retain the state version from their original installation.
  system.stateVersion = lib.mkDefault "26.05";
}
