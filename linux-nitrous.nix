{ pkgs, lib, config, ... }:

{
  environment.systemPackages = with pkgs; [ llvm_18 clang_18 lld_18 ];
  boot.kernelPackages = let
      llvm = pkgs.llvmPackages_18;
      localversion = "-nitrous4";
      linux_nitrous_pkg = { buildLinux, ... } @ args:

        buildLinux (args // rec {
          version = "6.11.0";
          modDirVersion = "${version}${localversion}";

          src = fetchTarball {
            url = "https://gitlab.com/xdevs23/linux-nitrous/-/archive/v6.11.0-3/linux-nitrous-v6.11.0-3.tar.gz";
            sha256 = "0f0rpxxssknqr7l73hqrq4ad20zlpv6h41j8n85w4fkz5s7z118j";
          };
#          defconfig = "nitrous_defconfig";
          allowImportFromDerivation = true;
          stdenv = pkgs.overrideCC llvm.stdenv (llvm.stdenv.cc.override { inherit (llvm) bintools; });
          extraMakeFlags = [
            "LLVM=1"
          ];

          structuredExtraConfig = with lib.kernel; {
            MNATIVE_AMD = yes;
            LOCALVERSION_AUTO = no;
            NTSYNC = yes;
            DEBUG_LIST = lib.mkForce no;
            LIST_HARDENED = yes;
            LATENCYTOP = no;
            BCACHEFS_FS = module;
            DRM_XE = module;
            DEBUG_INFO_BTF = lib.mkForce no;
            PREEMPT_VOLUNTARY = yes;
            CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
            KVM = yes;
            LTO_CLANG_THIN = yes;
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
              LOCALVERSION ${localversion}
              FS_SYSCTL_PROTECTED_FIFOS 2
              FS_SYSCTL_PROTECTED_REGULAR 2
              KPTR_RESTRICT 1
            '';
          } ];

#          extraMeta.branch = "6.10";
        } // (args.argsOverride or {}));
      linux_nitrous = pkgs.callPackage linux_nitrous_pkg{};
    in 
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_nitrous);
}
