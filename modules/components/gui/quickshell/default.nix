{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
{
  _module.args.wrapQuickshell =
    {
      config,
      additionalArgs ? "",
      name ? "quickshell-wrapped",
    }:
    pkgs.writeShellScriptBin name ''
      ${lib.getExe inputs.quickshell.packages.${system}.default} \
        -c "${config}" ${additionalArgs}
    '';
}
