{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 33;
  boot.kernel.sysctl = {
    "vm.page-cluster" = 0;
    "vm.swappiness" = 120;
  };
}
