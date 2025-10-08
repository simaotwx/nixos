{
  pkgs,
  lib,
  config,
  ...
}:
let
  amdGpuSupport = config.foundrix.hardware.gpu.amd.isSupported or false;
  intelGpuSupport = config.foundrix.hardware.gpu.intel.isSupported or false;
  rocmPackages = config.foundrix.hardware.gpu.amd.rocmPackages or [ ];

  ollamaPackage =
    if intelGpuSupport then
      pkgs.unstable.ollama
    else if amdGpuSupport then
      pkgs.unstable.ollama.override { acceleration = "rocm"; }
    else
      pkgs.unstable.ollama;
in
{
  environment.systemPackages = [
    ollamaPackage
  ]
  ++ (lib.optionals amdGpuSupport [
    (pkgs.writeShellScriptBin "ollama-rocm" ''
      #!${pkgs.runtimeShell}
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
      export HSA_OVERRIDE_GFX_VERSION="$major.$minor.$patch"
      exec ${lib.getExe ollamaPackage} "$@"
    '')
  ])
  ++ (lib.optionals intelGpuSupport [
    (pkgs.writeShellScriptBin "ollama-intel" ''
      #!${pkgs.runtimeShell}
      export OLLAMA_INTEL_GPU=1
      export SYCL_DEVICE_FILTER=level_zero:gpu
      export ZES_ENABLE_SYSMAN=1
      export SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
      exec ${lib.getExe ollamaPackage} "$@"
    '')
  ]);
}
