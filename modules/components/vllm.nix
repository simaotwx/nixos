{
  pkgs,
  lib,
  config,
  ...
}:
let
  amdGpuSupport = config.foundrix.hardware.gpu.amd.isSupported or false;
  intelGpuSupport = config.foundrix.hardware.gpu.intel.isSupported or false;
  rocmPackages = config.foundrix.hardware.gpu.amd.rocmPackages or { };

  vllmPackage =
    if intelGpuSupport then
      pkgs.vllm
    else if amdGpuSupport then
      pkgs.unstable.vllm.overrideAttrs (prev: {
        ROCM_PATH = prev.ROCM_HOME or "${rocmPackages.clr}";
        buildInputs = prev.buildInputs ++ (with rocmPackages; [
          rocrand
          rocblas
          hipblaslt
          rocsparse
          rocsolver
          rocprim
          rocthrust
          miopen
        ]);
      })
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
