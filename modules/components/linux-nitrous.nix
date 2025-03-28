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
        version = "6.13.8";
        suffix = "nitrous";
        linux_nitrous_pkg = { fetchurl, buildLinux, ... } @ args:

          buildLinux (args // rec {
            inherit version;
            pname = "linux-${suffix}";
            modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
            stdenv = pkgs.llvmPackages_19.stdenv;

            src = fetchurl {
              url = "https://gitlab.com/xdevs23/linux-nitrous/-/archive/v6.13.8-1/linux-nitrous-v6.13.8-1.tar.gz";
              hash = "sha256-ljIa8ipTrof47q54jnrcARlBzrAQm1VrmGPH5nPYUQo=";
            };

            structuredExtraConfig = with lib.kernel; {
              LOCALVERSION_AUTO = no;
              NTSYNC = yes;
              #DEBUG_LIST = lib.mkForce no;
              LIST_HARDENED = yes;
              #LATENCYTOP = no;
              BCACHEFS_FS = module;
              DRM_XE = module;
              #DEBUG_INFO_BTF = lib.mkForce no;
              #SCHED_CLASS_EXT = lib.mkForce no;
              #PREEMPT_LAZY = yes;
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