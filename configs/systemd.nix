{ config, pkgs, ... }:

let
  bin = ../bin;
in
{
  home.packages = with pkgs; [
    acpi
  ];


  systemd.user.startServices = true;


  systemd.user.services."check_battery" = {
    Unit = {
      Description = "check_battery";
    };
    Service = {
      Environment = ''
        "PATH=${pkgs.libnotify}/bin:
        ${pkgs.acpi}/bin:
        ${pkgs.coreutils}/bin:
        ${pkgs.gnugrep}/bin "
      '';
      ExecStart = "${bin}/check_battery";
    };
  };


  systemd.user.timers."check_battery" = {
    Unit = {
      Description = "Timer to check battery status";
    };
    Timer = {
      OnActiveSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };


  programs.zsh.shellAliases = {
    se = "sudoedit";

    # systemlevel
    start = "sudo systemctl start";
    stop = "sudo systemctl stop";
    restart = "sudo systemctl restart";
    status = "sudo systemctl status";
    enable = "sudo systemctl enable";
    disable = "sudo systemctl disable";

    # userlevel
    ustart = "systemctl --user start";
    ustop = "systemctl --user stop";
    urestart = "systemctl --user restart";
    ustatus = "systemctl --user status";
    uenable = "systemctl --user enable";
    udisable = "systemctl --user disable";
  };
}
