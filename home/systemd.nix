{ config, pkgs, ... }:

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
      ExecStart = "${config.dots.binDir}/check_battery";
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
}
