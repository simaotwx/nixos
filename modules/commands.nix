{ pkgs, lib, ... }: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "json2nix" ''
      #!${pkgs.runtimeShell}
      nix eval --arg-from-stdin stdin --expr "{ stdin }: { output = builtins.fromJSON stdin; }" output | \
        ${lib.getExe pkgs.nixfmt-rfc-style}
    '')
  ];
}