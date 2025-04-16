{ pkgs, nixosConfigurations, system, flakePath, ... }: pkgs.stdenv.mkDerivation rec {
  inherit system;
  name = "simao-htpc-kodi-factory-data";
  unpackPhase = "true";
  installPhase =
  let
    guisettings = pkgs.writeText "" (import "${flakePath}/src/${name}/userdata/guisettings.nix" nixosConfigurations.simao-htpc);
  in
  ''
    install -D ${guisettings} $out/userdata/guisettings.xml
    install -D \
      '${flakePath}/src/${name}/userdata/addon_data/skin.estuary/settings.xml' \
      $out/userdata/addon_data/skin.estuary/settings.xml
  '';
}