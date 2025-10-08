{
  pkgs,
  config,
  system,
  flakePath,
  ...
}@args:
pkgs.stdenv.mkDerivation rec {
  inherit system;
  name = "simao-htpc-kodi-factory-data";
  unpackPhase = "true";
  installPhase =
    let
      guisettings = pkgs.writeText "" (import "${flakePath}/src/${name}/userdata/guisettings.nix" args);
      youtubeSettings = pkgs.writeText "" (
        import "${flakePath}/src/${name}/userdata/addon_data/plugin.video.youtube/settings.nix" args
      );
      youtubeApiKeys = pkgs.writeText "" (
        import "${flakePath}/src/${name}/userdata/addon_data/plugin.video.youtube/api_keys.nix" args
      );
      jellyconSettings = pkgs.writeText "" (
        import "${flakePath}/src/${name}/userdata/addon_data/plugin.video.jellycon/settings.nix" args
      );
      jellyconAuth = pkgs.writeText "" (
        import "${flakePath}/src/${name}/userdata/addon_data/plugin.video.jellycon/auth.nix" args
      );
    in
    ''
      install -D ${guisettings} $out/userdata/guisettings.xml
      install -D {"${flakePath}/src/${name}","$out"}'/userdata/addon_data/skin.estuary/settings.xml'
      install -D {"${flakePath}/src/${name}","$out"}'/userdata/addon_data/inputstream.adaptive/settings.xml'
      install -D {"${flakePath}/src/${name}","$out"}'/userdata/addon_data/script.module.inputstreamhelper/settings.xml'
      install -D ${youtubeSettings} $out/userdata/addon_data/plugin.video.youtube/settings.xml
      install -D ${youtubeApiKeys} $out/userdata/addon_data/plugin.video.youtube/api_keys.json
      install -D ${jellyconSettings} $out/userdata/addon_data/plugin.video.jellycon/settings.xml
      install -D ${jellyconAuth} $out/userdata/addon_data/plugin.video.jellycon/auth.json
    '';
}
