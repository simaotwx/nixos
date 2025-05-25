{ pkgs, lib, ... }: pkgs.stdenv.mkDerivation rec {
  name = "amdgpu-custom-fancontrol";
  src = pkgs.fetchFromGitHub {
    owner = "grmat";
    repo = "amdgpu-fancontrol";
    rev = "42f7faa3a237ead71f467fbf12aee7de93311eb0";
    hash = "sha256-aXpWpIz6ghSoSZ4BcOwa7wRE6ZChwkHEbTyAwRNaIW0=";
  };
  installPhase = ''
    mkdir -p $out/bin
    tail -n+20 amdgpu-fancontrol | cat ${pkgs.writeText "" ''
      #!${lib.getExe pkgs.bash}
      HYSTERESIS=4000
      SLEEP_INTERVAL=0.5
      DEBUG=true
      TEMPS=( 60000 65000 70000 80000 90000 )
      PWMS=(      0   60    90    153   255 )
      FILE_PWM=$(echo /sys/class/drm/card?/device/hwmon/hwmon?/pwm1)
      FILE_FANMODE=$(echo /sys/class/drm/card?/device/hwmon/hwmon?/pwm1_enable)
      FILE_TEMP=$(echo /sys/class/drm/card?/device/hwmon/hwmon?/temp2_input)
    ''} - > $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
  meta.mainProgram = name;
}