{ pkgs, lib, ... }:

{
  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock --daemonize";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        ignore_dbus_inhibit = false;
      };
      
      listener = [
        {
          timeout = 180;
          on-timeout = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 185;
          on-timeout = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock --daemonize";
        }
        {
          timeout = 190;
          on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          on-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
