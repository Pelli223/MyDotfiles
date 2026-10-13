{pkgs, ... }:

{

  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    options = "caps:escape";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session --user-menu \
                   --user-menu \
                   --remember \
                   --remember-session \
                   --remember-user-session \
                   --asterisks \
                   --exclude-user nixbld* \
                   ;";
        user = "pelli";
      };
    };
  };

# Enable CUPS to print documents.
#services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.libinput.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.openssh = {
    enable = true;
  };

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;  # Usa la versión con soporte para drivers de terceros
      tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-broadcom;
  };
}
