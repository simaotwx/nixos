{ pkgs, lib, ... }: {
  hardware.graphics.enable32Bit = lib.mkForce false;
  hardware.asahi.useExperimentalGPUDriver = true;
  environment.systemPackages = with pkgs; [
    asahi-btsync asahi-wifisync asahi-bless asahi-nvram
  ];
}