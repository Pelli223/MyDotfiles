{ pkgs, lib, ... }:

{
  services.swayidle =
    let
# Lock command
    lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
  display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in
  {
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
      timeout = 190;
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
