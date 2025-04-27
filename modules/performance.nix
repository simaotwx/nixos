{ lib, config, ... }: {
  options = {
    customization.performance = {
      tuning.enable = lib.mkEnableOption "performance tuning";
      oomd.enable = lib.mkEnableOption "OOMD";
    };
  };

  config =
  let
    cfg = config.customization.performance;
  in
  {
    # https://src.fedoraproject.org/rpms/systemd/tree/f42
    systemd.oomd = lib.mkIf cfg.oomd.enable {
      enable = lib.mkForce true;
      enableRootSlice = lib.mkDefault true;
      enableUserSlices = lib.mkDefault true;
      enableSystemSlice = lib.mkDefault true;
      extraConfig = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };
    services.bpftune.enable = lib.mkDefault cfg.tuning.enable;
  };
}