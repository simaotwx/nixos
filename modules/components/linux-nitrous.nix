{ pkgs, lib, config, ... }:

{
  options = {
    customization.linux-nitrous = {
      cpuVendor = lib.mkOption {
        type = lib.types.enum [ "amd" "intel" ];
        description = "Which vendor to build -march=native for";
      };
    };
  };
  config = {
    customization.linux-nitrous.cpuVendor = config.customization.hardware.cpu.vendor;
    boot.kernelPackages = lib.mkOverride 80 (let
        version = "6.14.1-1";
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
            ];

            src = fetchurl {
              url = "https://gitlab.com/xdevs23/linux-nitrous/-/archive/v${version}/linux-nitrous-v${version}.tar.gz";
              hash = "sha256-shFsAPj5yJTj6nDMwfmLXU2KCMM5jT56IBsVAJ8rkkc=";
            };

            structuredExtraConfig = with lib.kernel; {
              LOCALVERSION_AUTO = no;
              NTSYNC = yes;
              LIST_HARDENED = yes;
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
              if config.customization.linux-nitrous.cpuVendor == "amd" then {
                MNATIVE_AMD = yes;
              } else if config.customization.linux-nitrous.cpuVendor == "intel" then {
                MNATIVE_INTEL = yes;
              } else {}
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