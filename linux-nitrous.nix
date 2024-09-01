{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ llvm_18 clang_18 lld_18 ];
  boot.kernelPackages = let
      llvm = pkgs.llvmPackages_18;
      linux_nitrous_pkg = { fetchgit, buildLinux, ... } @ args:

        buildLinux (args // rec {
          version = "6.10.7";
          modDirVersion = "${version}-nitrous";

          src = builtins.fetchGit {
            url = "https://gitlab.com/xdevs23/linux-nitrous.git";
            ref = "refs/heads/v6.10+";
          };
          kernelPatches = [];
          defconfig = "nitrous_defconfig";
          allowImportFromDerivation = true;
          stdenv = pkgs.overrideCC llvm.stdenv (llvm.stdenv.cc.override { inherit (llvm) bintools; });
          extraMakeFlags = [
            "LLVM=1"
          ];

          structuredExtraConfig = with lib.kernel; {
            MNATIVE_AMD = yes;
          };

#          extraMeta.branch = "6.10";
        } // (args.argsOverride or {}));
      linux_nitrous = pkgs.callPackage linux_nitrous_pkg{};
    in 
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_nitrous);
}
