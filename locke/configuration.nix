# Native machine settings; shared settings live one directory above.
{ config, lib, pkgs, ... }:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [ ./hardware-configuration.nix ];
  home-manager.users.jdb = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Note this might jump back and forth as kernels are added or removed.
  boot.kernelPackages = latestKernelPackage;
  boot.zfs.forceImportRoot = false;
  # boot.initrd.luks.devices."luks-2c66f21c-f35d-406f-abc9-2bf63e973cc5".device =
  #  "/dev/disk/by-uuid/2c66f21c-f35d-406f-abc9-2bf63e973cc5";

  networking.hostName = "locke";
  networking.networkmanager.enable = true;
  users.users.jdb.extraGroups = [ "networkmanager" ];

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    proton-vpn
    protonmail-desktop
    spotify
  ];

  services.resilio = {
    enable = true;
    checkForUpdates = false;
    deviceName = "locke";
    enableWebUI = true;
    httpListenAddr = "127.0.0.1";
    httpListenPort = 8888;
    directoryRoot = "/home/jdb";
    listeningPort = 4444;
    downloadLimit = 0;
    uploadLimit = 0;
  };
  users.users.rslsync = {
    isSystemUser = true;
    extraGroups = [ "jdb" "rslsync" ];
  };
  systemd.tmpfiles.rules = [ "Z /home/jdb 0775 jdb jdb -" ];
  networking.firewall.allowedTCPPorts = [ 4444 ];
}
