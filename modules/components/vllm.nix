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

  vllmPackage =
    if intelGpuSupport then
      pkgs.vllm
    else if amdGpuSupport then
      pkgs.unstable.vllm.override { inherit rocmPackages; }
    else
      pkgs.vllm;

  rocmScript = config.foundrix.hardware.gpu.amd.rocmScript;
in
{
  environment.systemPackages = [
    vllmPackage
  ]
  ++ (lib.optionals amdGpuSupport [
    (rocmScript "vllm-rocm" ''
      exec ${lib.getExe' vllmPackage "vllm"} "$@"
    '')
  ]);
}
