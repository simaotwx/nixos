{ pkgs, config, ... }: {
  environment.systemPackages =
  let
    ollamaPackage = (pkgs.ollama.override {
      acceleration = if config.customization.graphics.amd.enable then "rocm" else "cuda";
    });
  in
  with pkgs; [
    goose-cli
    ollamaPackage
    (writeShellScriptBin "ollama-rocm" ''
      #!${runtimeShell}
      gfxver="$(${lib.getExe' rocmPackages.rocminfo "rocminfo"} | grep 'Name' | grep 'gfx' | head -n1 | ${lib.getExe gawk} '{ print $2 }')"
      export HCC_AMDGPU_TARGET="$gfxver"
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
      export HSA_OVERRIDE_GFX_VERSION="$major.$minor.$patch"
      exec ${lib.getExe ollamaPackage} "$@"
    '')
  ];

}