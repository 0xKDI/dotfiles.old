{ config, lib, pkgs, ... }:

{

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = "performance";

  hardware.cpu.intel.updateMicrocode = true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
