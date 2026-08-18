# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # <nixos-hardware/dell/xps/15-9560>
      # For building VMs with flakes
      # "${modulesPath}/virtualisation/qemu-vm.nix"
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # virtualisation.forwardPorts = [
  #   {
  #     from = "host";
  #     host.port = 2221;
  #     guest.port = 22;
  #   }
  # ];
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 2;
      graphics = false;
    };
  };

  # Desktop
  ########################################
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jdb = {
    isNormalUser = true;
    description = "jdb";
    extraGroups = [ 
      "media"
      "networkmanager" 
      "wheel" 
    ];
    packages = with pkgs; [ 
      #
    ];
    openssh.authorizedKeys.keys = 
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFb2aohIi0NGBlyAQENVbXe5JgerjiTgMT/1ZxB8wFA8 jeremydb@protonmail.com"
      ];
  };
  services.displayManager.autoLogin.user = "jdb";

  programs.firefox.enable = true;
  programs.tmux.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim 
  ];

  # Media Server
  ########################################
  users.groups = {
    media = {};
  };
  services.plex = {
    enable = true;
    openFirewall = true;
    group = "media";
    accelerationDevices = [
      "*"
    ];
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };
  services.prowlarr = {
   enable = true;
   openFirewall = true;
   # group = "media";
 };


  # Lab Infrastructure 
  ########################################
  virtualisation.oci-containers = {
    # backend defaults to "podman"
    containers = {

      pihole = {
        image = "pihole/pihole:latest";
        ports = [
        # "127.0.0.1:3010:3010"
        #   # DNS Ports
        # "53:53/tcp"
        # "53:53/udp"
        # # Default HTTP Port
        # "80:80/tcp"
        # # Default HTTPs Port. FTL will generate a self-signed certificate
        # "443:443/tcp"
        # # Uncomment the line below if you are using Pi-hole as your DHCP server
        # "67:67/udp"
        ];
	networks = [
          "host"
	];
        volumes = [
          "/etc/pihole:/etc/pihole"
        ];
        environment = {
          TZ = "America/New_York";
          # Set a password to access the web interface. Not setting one will result in a random password being assigned
          FTLCONF_webserver_api_password = "correct horse battery staple";
          # If using Docker's default `bridge` network setting the dns listening mode should be set to 'all'
          FTLCONF_dns_listeningMode = "all";
        };
        capabilities = {
          # Required if you are using Pi-hole as your DHCP server, else not needed
          NET_ADMIN = true;
          # Required if you are using Pi-hole for your NTP client 
	  # to be able to set the host's system time
          SYS_TIME = true;
          # Optional, if Pi-hole should get some more processing time
          SYS_NICE = true;
        };
        autoStart = true;
	privileged = true;
      };

      transmission_openvpn = {
        image = "haugene/transmission-openvpn:latest";
        ports = [
          "9091:9091"
        ];
        volumes = [
          "/data/torrents:/data/torrents"
          "/data/torrents/incomplete:/data/torrents/incomplete"
	  "/etc/transmission/:/config"
        ];
        environment = {
          TZ = "America/New_York";
          OPENVPN_PROVIDER = "PROTONVPN";
          OPENVPN_CONFIG = "ch.protonvpn.udp,mx.protonvpn.udp,es.protonvpn.udp,nl.protonvpn.udp,ca.protonvpn.udp"; 
	  OPENVPN_USERNAME = "**None**";
	  OPENVPN_PASSWORD = "**None**";
	  LOCAL_NETWORK = "192.168.1.0/24";
	  DISABLE_PORT_FORWARDER = "false";
	  OPENVPN_OPTS = "--inactive 3600 --ping 10 --ping-exit 60";
        };
        capabilities = {
          NET_ADMIN = true;
          NET_RAW = true;
          MKNOD = true;
        };
        autoStart = true;
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    # Create the default bridge network for podman
    defaultNetwork.settings.dns_enabled = false;
  };

  # Networking
  ########################################
  networking.hostId = "a9535e5b";
  networking.hostName = "archimedes"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 
                                          53
                                        ];
  networking.firewall.allowedUDPPorts = [ 53 
                                        ];
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.X11Forwarding = true;
  };

  # Storage
  ########################################
  services.zfs.autoScrub.enable = true;


  # OS Administration 
  ########################################
  # Set your time zone.
  time.timeZone = "America/New_York";
  # Select internationalisation properties.
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

  services.logind.settings.Login.HandleLidSwitch = "poweroff";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "lock";
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.extraFiles = {
  #   "loader/keys/luks.key".source = "/etc/cryptsetup-keys.d/luks.key";
  # };
  # boot.initrd.luks.devices."luks-7f443307-a8ec-48b0-9939-8cec271bb9a8".device = "/dev/disk/by-uuid/7f443307-a8ec-48b0-9939-8cec271bb9a8";
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "mediapool" ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
