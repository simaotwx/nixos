{
  # sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/nvme0n1p2
  boot.initrd.systemd.tpm2.enable = true;
  systemd.tpm2.enable = true;
  security.tpm2.enable = true;
}