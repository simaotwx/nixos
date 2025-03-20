{ lib, config, pkgs, ... }: {
  system.stateVersion = "24.11";

  boot.tmp = {
    useTmpfs = !config.customization.hardware.mem.lowMemory;
  };

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  security.pam.loginLimits = [{
    type = "hard";
    domain = "*";
    item = "nofile";
    value = "1048576";
  }];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  boot.kernelPackages = lib.mkOverride 100 pkgs.linuxPackages_latest;
}