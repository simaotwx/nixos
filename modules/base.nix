{
  lib,
  config,
  pkgs,
  ...
}:
{
  system.stateVersion = lib.mkDefault "24.11";

  boot.tmp = {
    useTmpfs = !config.customization.hardware.mem.lowMemory;
  };
  boot.kernelParams = [ "boot.shell_on_fail" ];

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  security.pam.loginLimits = [
    {
      type = "hard";
      domain = "*";
      item = "nofile";
      value = "1048576";
    }
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  environment.systemPackages = with pkgs; [
    lsof
    file
  ];

  boot.kernelPackages = lib.mkOverride 101 pkgs.linuxPackages_latest;

  services.dbus.enable = true;
}
