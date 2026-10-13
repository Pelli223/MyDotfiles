{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./packages.nix
    ./services.nix
    ];

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "pelli-nixos"; 

# Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

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
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  systemd.user.services.niri.enableDefaultPath = false;

  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;

  security.polkit.enable = true;
  security.pam.services.swaylock.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  virtualisation.spiceUSBRedirection.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pelli = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" "libvirtd" "fprintd"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      tree
      ];
  };

  programs.firefox.enable = true;
  programs.waybar.enable = true;
  programs.kdeconnect.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05"; 
}

