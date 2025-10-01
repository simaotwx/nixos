{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: with pkgs; {
      crush-latest =
      (master.crush.overrideAttrs (old: rec {
        version = "0.9.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-VFAGjNtXKNjkv8Ryi28oFN/uLomXXdw6NFtyjT3pMEY=";
        };
        vendorHash = "sha256-ktF3kIr143uPwiEbgafladZRqIsmG6jI2BeumGSu82U=";
        patches = [];
      }));
    })
  ];
}