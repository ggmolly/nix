# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = ["r8169"];
    systemd.users.root.shell = "/bin/cryptsetup-askpass";
    network = {
       enable = true;
       ssh = {
         enable = true;
         port = 22;
         authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDlSU9uPDhrLwcZ9gH5HZgLjUbpn66cxvUFjOlhUSCKk" ];
         hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
       };
    };
  };


  networking.hostName = "formidable"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

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

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    videoDrivers = ["nvidia"];
    exportConfiguration = true;
  };

  services.displayManager = {
     defaultSession = "none+i3";
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,fr";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.molly = {
    isNormalUser = true;
    description = "molly";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;

  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.molly = { pkgs, ...}: {
    home.packages = [
      pkgs.i3
      pkgs.i3-gaps
      pkgs.alacritty
      pkgs.restic
      pkgs.librewolf
      pkgs.btop
      pkgs.discord
      pkgs.polybar
      pkgs.vscode
      pkgs.yazi
      pkgs.eza
      pkgs.ncdu
      pkgs.p7zip
      pkgs.rofi
      pkgs.rofi-calc
      pkgs.ncmpcpp
      pkgs.mpd
      pkgs.mpc-cli
      pkgs.dunst
      pkgs.rofi-calc
      pkgs.rofi-screenshot
      pkgs.xkb-switch-i3
      pkgs.libnotify
      pkgs.feh
      pkgs.freetube
      pkgs.bun
      pkgs.mpv
      pkgs.air
      pkgs.dbeaver-bin
    ];


    home.stateVersion = "24.05";
  };

  virtualisation.docker.enable = true;
 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget  
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    python310
    python312
    go
    gcc
    clang
    libcap
  ];

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Sound settings
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  networking.firewall.enable = false;

  nix.extraOptions = ''
    trusted-users = root molly
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
