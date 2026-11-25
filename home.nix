{ config, pkgs, ... }:
let
  cfgs = "${config.home.homeDirectory}/src/playa/dotfiles";
  ln = src: config.lib.file.mkOutOfStoreSymlink src;
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jdb";
  home.homeDirectory = "/home/jdb";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # apps
    spotify-player
    libreoffice-fresh 
    obsidian 

    # fonts
    nerd-fonts.jetbrains-mono

    # programming
    cargo
    gcc
    just
    nodejs

    # shell utilities
    fzf
    gnupg
    jq
    ripgrep
    tmux
    tree

    # system monitoring
    btop
    dnsutils
    iftop
    iotop
    nmap
    pciutils
    strace
    usbutils
    unzip
  ];

  xdg.enable = true;
  xdg.configFile."nvim".source = ln "${cfgs}/nvim.lazy";
  home.file = {
    ".bash_aliases".source = ln "${cfgs}/.bash_aliases";
    ".bash_profile".source = ln "${cfgs}/.bash_profile";
    ".bashrc".source = ln "${cfgs}/.bashrc";
    ".envrc".source = ln "${cfgs}/.envrc";
    ".gitconfig".source = ln "${cfgs}/.gitconfig";
    ".gitignore".source = ln "${cfgs}/.gitignore";
    ".inputrc".source = ln "${cfgs}/.inputrc";
    ".tmux.conf".source = ln "${cfgs}/.tmux.conf";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jdb/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    sideloadInitLua = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };
}
