# Native machine settings; shared settings live one directory above.
{ pkgs, ... }:
{
  imports = [ ../hardware-configuration.nix ];
  home-manager.users.jdb = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-2c66f21c-f35d-406f-abc9-2bf63e973cc5".device =
    "/dev/disk/by-uuid/2c66f21c-f35d-406f-abc9-2bf63e973cc5";

  networking.hostName = "locke";
  networking.networkmanager.enable = true;
  users.users.jdb.extraGroups = [ "networkmanager" ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
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
