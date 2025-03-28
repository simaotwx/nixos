{ lib, config, pkgs, ... }: {
  options = {
    customization.shell = {
      simaosSuite.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Simao's suite of aliases and functions";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  (lib.mkMerge [
    (lib.mkIf customization.shell.simaosSuite.enable {
      environment.shellAliases = {
        gpick = "git cherry-pick -s";
      };
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "pickrange" ''
          git rev-list --reverse --topo-order $1^..$2 | while read rev
          do echo "$rev"; done | xargs git cherry-pick -s
        '')
      ];
    })
  ]);
}