{ lib, config, pkgs, ... }: {
  options = {
    customization = {
      virtualisation.virtd.users = lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        description = "Which users to apply virtd support to. Defaults to all users.";
      };
    };
  };

  config = {
    users.users = lib.genAttrs config.customization.virtualisation.virtd.users (username: {
      extraGroups = [ "libvirtd" ];
    });
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
  };
}