# Windows supplies the kernel, disks, networking, audio, and WSLg display.
{ ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "jdb";
  networking.hostName = "pirsig";

  # This WSL installation was first created on NixOS 26.05.
  system.stateVersion = "26.05";
  # home-manager.users.jdb.home.stateVersion = "26.05";
}
