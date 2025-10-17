{ lib, pkgs, rocmPackages, ... }:
  name: script: pkgs.writeShellScriptBin name ''
    gfxver="$(${lib.getExe' rocmPackages.rocminfo "rocminfo"} | grep 'Name' | grep 'gfx' | head -n1 | ${lib.getExe pkgs.gawk} '{ print $2 }')"
    version_digits=''${gfxver#gfx}
    num_digits=''${#version_digits}
    if [ "$num_digits" -eq 4 ]; then
      major=''${version_digits:0:2}
      minor=''${version_digits:2:1}
      patch=''${version_digits:3:1}
    elif [ "$num_digits" -eq 3 ]; then
      major=''${version_digits:0:1}
      minor=''${version_digits:1:1}
      patch=''${version_digits:2:1}
    fi
    if [ "$version_digits" == "1103" ]; then
      # 1103 is not supported, it just does not appear in the list, let's use 1102 instead
      patch=2
    fi
    export HSA_OVERRIDE_GFX_VERSION="$major.$minor.$patch"
    ${script}
  ''