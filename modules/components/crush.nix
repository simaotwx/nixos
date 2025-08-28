{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: with pkgs; {
      crush-latest =
      # as of 2025-08-24, Go 1.25 is only in master and Crush >= 0.6.3 needs 1.25
      ((master.crush.overrideAttrs (old: rec {
        version = "0.7.1";
        src = old.src.override {
          inherit version;
          hash = "sha256-3wBGN3Uit1Xw8ZQ4WyR4PhA66Cfhl6YljMEbpaaJP60=";
        };
        vendorHash = "sha256-qUcgVu6+cSFYDCsIB1pB5Vy3adWua2Rs8P9SNXJEjcA=";
        patches = [
          (fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/charmbracelet/crush/pull/746.diff";
            hash = "sha256-ANPvNwq0rq8SpoU6C2Jse6fqWngFJ7uoaU5i+PRz4QU=";
          })
        ];
      })).override { buildGoModule = master.buildGo125Module; });
    })
  ];
}