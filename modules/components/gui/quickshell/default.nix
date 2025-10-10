{
  inputs,
  system,
  pkgs,
  lib,
  config,
  ...
}:
let
  nixConfig = config;
in
{
  _module.args.wrapQuickshell =
    {
      config,
      additionalArgs ? "",
      name ? "quickshell-wrapped",
    }:
    pkgs.writeShellScriptBin name ''
      export QS_NO_RELOAD_POPUP=1
      ${
        lib.getExe
          (
            if nixConfig.customization.hardware.graphics.latestMesa then
              inputs.quickshell-unstable
            else
              inputs.quickshell
          ).packages.${system}.default
      } \
        -c "${config}" ${additionalArgs}
    '';
}
