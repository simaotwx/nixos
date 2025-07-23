{ pkgs, ... }:
let
  tuneType = "gaming";
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
  set -e
  USER_STATES_PATH=${tune}/ amdgpu-clocks
  set -x
  echo manual > /sys/class/drm/card?/device/power_dpm_force_performance_level
  echo 1 > /sys/class/drm/card?/device/pp_power_profile_mode
  set +x
''
