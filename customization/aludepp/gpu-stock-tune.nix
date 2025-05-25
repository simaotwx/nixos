{ pkgs, lib, ... }:
let
  tuneType = "stock";
  tune = pkgs.stdenv.mkDerivation rec {
    name = "gpu-${tuneType}-tune-states";
    pname = "amdgpu-clocks-${name}";
    src = ./gpu-tunes;
    installPhase = ''
      for i in {0..9}; do
        install -D "${tuneType}" "$out/amdgpu-custom-state.card$i"
      done
    '';
  };
  in
  pkgs.writeShellScriptBin "gpu-${tuneType}-tune" ''
    #!${lib.getExe pkgs.bash}
    set -e
    echo manual > /sys/class/drm/card?/device/power_dpm_force_performance_level
    sleep 0.25
    echo 1 > /sys/class/drm/card?/device/pp_dpm_mclk
    echo "0 1" > /sys/class/drm/card?/device/pp_dpm_mclk
    echo 0 > /sys/class/drm/card?/device/pp_dpm_mclk
    echo 0 > /sys/class/drm/card?/device/pp_dpm_sclk
    USER_STATES_PATH=${tune} amdgpu-clocks
    set -x
    echo 0 > /sys/class/drm/card?/device/pp_power_profile_mode || :
    echo auto > /sys/class/drm/card?/device/power_dpm_force_performance_level
    set +x
  ''