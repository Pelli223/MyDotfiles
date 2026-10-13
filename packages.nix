{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    "vscode"
    "libfprint-2-tod1-broadcom"
    "discord-canary"
    ];

  environment.systemPackages = with pkgs; [
      wget
      neovim
      kitty
      rofi
      git
      swaylock-effects
      xwayland-satellite
      btop
      swaybg
      zoxide
      fzf
      pywal
      wlogout
      brightnessctl
      playerctl
      keepassxc
      fastfetch
      zapzap
      telegram-desktop
      logiops
      cliphist
      wl-clipboard
      tree-sitter
      gthumb
      logiops
      nautilus
      libnotify
      pavucontrol
      unzip
      sway-audio-idle-inhibit
      expect
      gpclient
      grim
      slurp
      satty
      ];
}
