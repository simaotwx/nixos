{
  config,
  options,
  lib,
  pkgs,
  ...
}:
{
  options = {
    customization.graphics.intel.rgbFix = lib.mkEnableOption "full range RGB fix for non-compliant monitors";
  };
  config =
    let
      hasLinuxNitrous = builtins.hasAttr "linux-nitrous" options.customization;
      intelRgbFix = pkgs.writeShellScript "intel-rgb-fix" ''
        set +e
        while ! ${lib.getExe' pkgs.libdrm "proptest"} -M xe -D /dev/dri/card* 2>/dev/null | grep -q "Broadcast RGB"; do
          sleep 0.5
        done

        (
        set -e
        ${lib.getExe' pkgs.libdrm "proptest"} -M xe -D /dev/dri/card* | grep -E "^Connector [0-9]+" | while read -r line; do
          connector=$(echo "$line" | ${lib.getExe pkgs.gawk} '{print $2}')

          prop_info=$(${lib.getExe' pkgs.libdrm "proptest"} -M xe -D /dev/dri/card* | grep -B9999999 "Connector $connector" | grep "Broadcast RGB" | head -n1)
          prop_id=$(echo "$prop_info" | sed -re "s/[^0-9]*?([0-9]+).*?/\1/")

          if [ -n "$prop_id" ]; then
            ${lib.getExe' pkgs.libdrm "proptest"} -M xe -D /dev/dri/card* "$connector" connector "$prop_id" 1
          fi
        done
        ) || :
      '';
    in
    rec {
      boot.initrd.kernelModules = [ "xe" ];
      environment.variables = {
        VDPAU_DRIVER = "va_gl";
        LIBVA_DRIVER_NAME = "iHD";
      };
      environment.systemPackages = with pkgs; [
        intel-gmmlib
      ];
      hardware.enableRedistributableFirmware = true;
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

      services.udev = lib.optionalAttrs config.customization.graphics.intel.rgbFix {
        extraRules = ''
          ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card[0-9]", DRIVERS=="xe", TAG+="systemd", ENV{SYSTEMD_WANTS}+="intel-rgb-fix.service"
          ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="intel-rgb-fix.service"
        '';
      };

      systemd.services =
        (lib.optionalAttrs config.customization.graphics.intel.rgbFix {
          intel-rgb-fix = {
            description = "Fix Intel RGB Range";

            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${intelRgbFix}";
              RemainAfterExit = false;
              StandardOutput = "journal";
              StandardError = "journal";
              PrivateDevices = false;
              ProtectKernelTunables = false;
              ProtectControlGroups = false;
              ProtectHome = false;
              PrivateTmp = false;
            };
          };
        })
        // {
          jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
        };

      boot.initrd.systemd.services.intel-rgb-fix = lib.mkIf (
        systemd.services ? intel-rgb-fix
      ) systemd.services.intel-rgb-fix;

      boot.initrd.services.udev.rules =
        lib.mkIf config.customization.graphics.intel.rgbFix services.udev.extraRules;

    }
    // lib.optionalAttrs hasLinuxNitrous {
      customization.linux-nitrous.enableDrmXe = true;
    };
}
