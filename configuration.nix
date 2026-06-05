{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pelli-nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "es";
    useXkbConfig = true; # use xkb.options in tty.
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;
  services.blueman.enable = true;

  users.defaultUserShell = pkgs.zsh;
  

  # 2. Habilitar greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session --user-menu \
          --user-menu-min-uid 1000 \
          --remember \
          --remember-user-session \
          --asterisks \
        ;";
        user = "pelli";
      };
    };
  };

  systemd.user.services.niri.enableDefaultPath = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    options = "caps:escape";
  };
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  services.openssh = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pelli = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) 
  [
    "discord"
  ];

  programs.firefox.enable = true;
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    neovim
    kitty
    rofi
    git
    swaylock
    swayidle
    xwayland-satellite
    btop
    zed-editor
    swaybg
    zsh
    zoxide
    fzf
    pywal
    wlogout
    brightnessctl
    playerctl
    keepassxc
    fastfetch
    zapzap
    discord
    logiops
    cliphist
    wl-clipboard
    pcmanfm
    tree-sitter
    pix
    logiops
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05"; 

}

