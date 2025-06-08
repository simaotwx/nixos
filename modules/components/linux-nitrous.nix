{ pkgs, lib, config, ... }:

{
  options = {
    customization.linux-nitrous = {
      processorFamily = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [
          # Intel
          "nocona" "core2" "penryn" "bonnell" "atom" "silvermont" "slm" "goldmont" "goldmont-plus"
          "tremont" "nehalem" "corei7" "westmere" "sandybridge" "corei7-avx" "ivybridge" "core-avx-i"
          "haswell" "core-avx2" "broadwell" "skylake" "skylake-avx512" "skx" "cascadelake" "cooperlake"
          "cannonlake" "icelake-client" "rocketlake" "icelake-server" "tigerlake" "sapphirerapids"
          "alderlake" "raptorlake" "meteorlake" "arrowlake" "arrowlake-s" "lunarlake"
          "gracemont" "pantherlake" "sierraforest" "grandridge" "graniterapids" "graniterapids-d"
          "emeraldrapids" "clearwaterforest" "diamondrapids"
          # AMD
          "knl" "knm" "k8" "athlon64" "athlon-fx" "opteron" "k8-sse3"
          "athlon64-sse3" "opteron-sse3" "amdfam10"
          "barcelona" "btver1" "btver2"
          "bdver1" "bdver2" "bdver3" "bdver4"
          "znver1" "znver2" "znver3" "znver4" "znver5"
          # Generic
          "x86-64" "x86-64-v2" "x86-64-v3" "x86-64-v4"
        ]);
        default = null;
      };
    };
  };
  config = {
    boot.kernelPackages = lib.mkOverride 80 (let
        version = "6.15.0";
        linuxVersion = lib.head (lib.splitString "-" version);
        suffix = "nitrous";
        llvm = pkgs.llvmPackages_20;
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
            ] ++
            (let processorFamily = config.customization.linux-nitrous.processorFamily; in
              if processorFamily != null then [
                "KCPPFLAGS=-march=${processorFamily}"
                "KCFLAGS=-march=${processorFamily}"
                "KRUSTFLAGS=-Ctarget-cpu=${processorFamily}"
              ] else [ ]
            );

            src = fetchurl {
              url = "https://gitlab.com/xdevs23/linux-nitrous/-/archive/v${version}/linux-nitrous-v${version}.tar.gz";
              hash = "sha256-DoVIByz9UjfKFQm80a1SdxVCVapElDtxqKntPz0XDrE=";
            };

            structuredExtraConfig = with lib.kernel; {
              LOCALVERSION_AUTO = no;
              NTSYNC = yes;
              #LATENCYTOP = no;
              BCACHEFS_FS = module;
              DRM_XE = if config.customization.graphics.intel.xe.enable then module else no;
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
            };

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