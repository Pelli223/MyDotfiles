{ pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;

    timeouts = [
# Primer aviso: notificación a los 180 segundos
    {
      timeout = 180;
      command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
    }

# Bloqueo de pantalla a los 185 segundos (5 segundos después del aviso)
    {
      timeout = 185;
      command = "pidof swaylock || ${pkgs.swaylock-effects}/bin/swaylock --daemonize";
    }

# Apagar monitores a los 190 segundos
    {
      timeout = 190;
      command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
    }

# Suspender sistema a los 300 segundos
    {
      timeout = 300;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }
    ];
  };
}
