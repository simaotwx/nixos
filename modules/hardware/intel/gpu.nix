{ options, lib, pkgs, ... }: {
  config =
  let
    hasLinuxNitrous = builtins.hasAttr "linux-nitrous" options.customization;
  in {
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
      LIBVA_DRIVER_NAME = "iHD";
    };
    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
    environment.systemPackages = with pkgs; [
      intel-gmmlib
    ];
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime
        vpl-gpu-rt
        mesa
      ];
    };
  } // lib.optionalAttrs hasLinuxNitrous {
    customization.linux-nitrous.enableDrmXe = true;
  };
}