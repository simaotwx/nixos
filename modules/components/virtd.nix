{
  config,
  pkgs,
  mkConfigurableUsersOptionOld,
  forEachUser,
  ...
}:
{
  options = {
    customization = {
      virtualisation.virtd.users = mkConfigurableUsersOptionOld {
        description = "Which users to apply virtd support to. Defaults to all users.";
      };
    };
  };

  config = {
    users.users = forEachUser config.customization.virtualisation.virtd.users {
      extraGroups = [ "libvirtd" ];
    };
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };
}
