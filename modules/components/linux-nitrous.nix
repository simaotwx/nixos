{ pkgs, lib, config, ... }:

{
  options = {
    customization.linux-nitrous = {
      processorFamily = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [
          # Intel
          "486sx" "486" "586" "586tsc" "586mmx" "686"
          "pentiumii" "pentiumiii" "pentiumm" "pentium4"
          "psc" "atom" "core2" "nehalem" "westmere"
          "silvermont" "goldmont" "goldmontplus" "sandybridge"
          "ivybridge" "haswell" "broadwell" "skylake" "skylakex"
          "cannonlake" "icelake_client" "icelake_server" "cascadelake"
          "cooperlake" "tigerlake" "sapphirerapids" "rocketlake" "alderlake"
          "raptorlake" "meteorlake" "emeraldrapids"
          # AMD
          "k6" "k7" "k8" "k8sse3" "k10" "barcelona" "bobcat"
          "jaguar" "bulldozer" "piledriver" "steamroller" "excavator"
          "elan"
          "zen" "zen2" "zen3" "zen4" "zen5"
          # Others
          "crusoe" "efficeon"
          "winchipc6" "winchip3d"
          "geodegx1" "geode_lx"
          "cyrixiii"
          "viac3_2" "viac7"
        ]);
        default = null;
      };
    };
  };
  config = {
    boot.kernelPackages = lib.mkOverride 80 (let
        version = "6.14.8-1";
        linuxVersion = lib.head (lib.splitString "-" version);
        suffix = "nitrous";
        llvm = pkgs.llvmPackages_19;
        linux_nitrous_pkg = { fetchurl, buildLinux, ... } @ args:

          buildLinux (args // rec {
            inherit version;
            pname = "linux-${suffix}";
            modDirVersion = lib.versions.pad 3 "${linuxVersion}-${suffix}";
            stdenv = pkgs.overrideCC llvm.stdenv (llvm.stdenv.cc.override { inherit (llvm) bintools; });
            nativeBuildInputs = [ llvm.lld ];
            extraMakeFlags = [
              "LLVM=1"
              "LD=${llvm.lld}/bin/ld.lld"
              "CC=${lib.getExe llvm.clang-unwrapped}"
            ];

            src = fetchurl {
              url = "https://gitlab.com/xdevs23/linux-nitrous/-/archive/v${version}/linux-nitrous-v${version}.tar.gz";
              hash = "sha256-QnqYe/KYit/L++yzp+lUcYIoVm8Ja8c/Ta4YYTpV3gU=";
            };

            structuredExtraConfig = with lib.kernel; {
              LOCALVERSION_AUTO = no;
              NTSYNC = yes;
              #LATENCYTOP = no;
              BCACHEFS_FS = module;
              DRM_XE = if config.customization.graphics.intel.xe.enable then yes else no;
              #SCHED_CLASS_EXT = lib.mkForce no;
              PREEMPT_VOLUNTARY = lib.mkForce no;
              PREEMPT_LAZY = yes;
              CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
              KVM = yes;
              #LTO_CLANG_THIN = yes;
              USB_FEW_INIT_RETRIES = yes;
              ANDROID_BINDER_IPC = yes;
              ANDROID_BINDERFS = yes;
              FS_SYSCTL_PROTECTED_SYMLINKS = yes;
              FS_SYSCTL_PROTECTED_HARDLINKS = yes;
            } // (
              if config.customization.linux-nitrous.processorFamily != null then {
                "M${lib.toUpper config.customization.linux-nitrous.processorFamily}" = yes;
              } else {
                GENRIC_CPU = yes;
              }
            );

            kernelPatches = [ {
              name = "nitrous-config";
              patch = null;
              extraConfig = ''
                LOCALVERSION -${suffix}
                FS_SYSCTL_PROTECTED_FIFOS 2
                FS_SYSCTL_PROTECTED_REGULAR 2
                KPTR_RESTRICT 1
              '';
            } ];

            extraMeta.branch = lib.versions.majorMinor version;
          } // (args.argsOverride or {}));
        linux_nitrous = pkgs.callPackage linux_nitrous_pkg {};
      in
        pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_nitrous));
  };
}