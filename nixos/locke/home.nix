# Desktop applications and the existing external editor configuration.
{ config, pkgs, ... }:
let
  cfgs = "${config.home.homeDirectory}/Backups/configs";
  ln = src: config.lib.file.mkOutOfStoreSymlink src;
in {
  home.packages = with pkgs; [ 
    libreoffice-fresh 
    obsidian 
  ];
  xdg.configFile."nvim".source = ln "${cfgs}/nvim.lazy";
}
