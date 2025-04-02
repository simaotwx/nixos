{
  virtualisation = {
    memorySize =  4096;
    cores = 4;
    qemu.options = [
      "-vga qxl"
      "-M q35"
      "-M accel=kvm:tcg"
      "-cpu host"
      "-smp sockets=1,dies=1,cores=4,threads=1"
    ];
  };
}