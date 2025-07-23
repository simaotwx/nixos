{
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/hardware/video/displaylink.nix"
  ];
  environment.systemPackages = [ pkgs.displaylink ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ evdi ];
  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages_latest = prev.linuxPackages_latest.extend (
        lpfinal: lpprev: {
          evdi = lpprev.evdi.overrideAttrs (
            efinal: eprev: rec {
              version = "1.14.10";
              src = prev.fetchFromGitHub {
                owner = "DisplayLink";
                repo = "evdi";
                rev = "v${version}";
                sha256 = "sha256-xB3AHg9t/X8vw5p7ohFQ+WuMjb1P8DAP3pROiwWkVPs=";
              };
            }
          );
        }
      );
      displaylink = prev.displaylink.override {
        inherit (final.linuxPackages_latest) evdi;
      };
    })
  ];
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
}
