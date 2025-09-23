{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: with pkgs; {
      opencode-latest =
      (master.opencode.overrideAttrs (old: rec {
        version = "0.11.2";
        src = old.src.override {
          tag = "v${version}";
          hash = "sha256-kWVDNGJS7QraLSlLh+JDvggDmskhQ0lAlKLnlmaGyQU=";
        };
        tui = old.tui.overrideAttrs (old: {
          vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
        });
      }));
    })
  ];
}