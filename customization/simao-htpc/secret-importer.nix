{ flakePath, ... }@args: {
  config =
    let
      localPath = "${flakePath}/local/simao-htpc-secrets.nix";
      path = if builtins.pathExists localPath then localPath else "${flakePath}/lib/empty.nix";
    in
      import path args;
}