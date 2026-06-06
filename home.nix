{ config, pkgs, inputs, ... }:

let
dotfiles = "${config.home.homeDirectory}/MyDotfiles/config";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

# Standard .config/directory
configs = {
  niri = "niri";
  nvim = "nvim";
  rofi = "rofi";
  kitty = "kitty";
  waybar = "waybar";
  swaylock = "swaylock";
};
in

{
  imports = [
    ./zsh.nix
  ];

  home.username = "pelli";
  home.homeDirectory = "/home/pelli";
  programs.git = {
    enable = true;
    settings.user.name = "Pelli223";
    settings.user.email = "dpelli.lafu@gmail.com";
  };

  home.stateVersion = "26.05";

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
     source = create_symlink "${dotfiles}/${subpath}";
     recursive = true;
     })
  configs;

  services.udiskie = {
    enable = true;
  };

  home.packages = with pkgs; [
    neovim
      ripgrep
      nodejs
      gcc
      rofi
      swaybg
      gnome-themes-extra    
      adwaita-qt
      nordic
      bibata-cursors
      inputs.sidra.packages.${pkgs.system}.default
  ];

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.gnome-themes-extra;
    };

    gtk3 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
    };
    gtk4 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk"; 
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 24;
    };
  };
}
