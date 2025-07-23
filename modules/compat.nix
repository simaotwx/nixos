{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    customization.compat = {
      enable = (lib.mkEnableOption "compatibility") // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.customization.compat.enable {
    # This allows programs to run that would normally not run under NixOS when
    # executed directly from a downloaded package, for example.
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      libGL
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      libpulseaudio
      libxkbcommon
      wayland

      libgcc
      gcc
    ];
  };
}
