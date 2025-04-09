{ pkgs, config, modulesPath, ... }: {
  imports = [
    "${modulesPath}/hardware/video/displaylink.nix"
  ];
  environment.systemPackages = [ pkgs.displaylink ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ evdi ];
  nixpkgs.overlays = [
  (final: prev: {
    linuxPackages_latest =
      prev.linuxPackages_latest.extend
        (lpfinal: lpprev: {
          evdi =
            lpprev.evdi.overrideAttrs (efinal: eprev: {
              version = "1.14.9-git";
              src = prev.fetchFromGitHub {
                owner = "DisplayLink";
                repo = "evdi";
                rev = "26e2fc66da169856b92607cb4cc5ff131319a324";
                sha256 = "sha256-Y8ScgMgYp1osK+rWZjZgG359Uc+0GP2ciL4LCnMVJJ8=";
              };
            });
        });
    displaylink = prev.displaylink.override {
      inherit (final.linuxPackages_latest) evdi;
    };
  })];
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
}