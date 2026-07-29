{ config, pkgs, ... }:

let
  # Lock command
  lock = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
  # Niri
  display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
    {
      timeout = 180; # in seconds
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
    }
    {
      timeout = 185;
      command = lock;
    }
    {
      timeout = 195;
      command = display "off";
      resumeCommand = display "on";
    }
    {
      timeout = 300;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }
    ];
    events = [
    {
      event = "before-sleep";
# adding duplicated entries for the same event may not work
      command = (display "off") + "; " + lock;
    }
    {
      event = "after-resume";
      command = display "on";
    }
    {
      event = "lock";
      command = (display "off") + "; " + lock;
    }
    {
      event = "unlock";
      command = display "on";
    }
    ];
  };
}
