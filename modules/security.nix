{ lib, config, ... }: {
  options = {
    customization = {
      security.network = {
        enable = lib.mkEnableOption "network security";
        strong = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enables strong network security. This may affect usability of
            certain applications like games. Some anti-cheat engines will
            refuse to start games if this is enabled.
          '';
        };
      };
      security.hardware.enable = lib.mkEnableOption "hardware security";
      security.kernel = {
        enable = lib.mkEnableOption "kernel security";
        strong = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enables strong kernel security. This may affect usability of
            certain applications. Some may crash or not even start.
          '';
        };
      };
      security.fs.enable = lib.mkEnableOption "FS security";
      security.userspace = {
        enable = lib.mkEnableOption "userspace security";
        strong = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enables strong userspace security. This may affect usability of
            certain applications. Some may crash or not even start.
          '';
        };
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkMerge [
    (lib.mkIf customization.security.network.enable (lib.mkMerge [
      (lib.mkIf customization.security.network.strong {
        boot.kernel.sysctl = {
          "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
          "net.core.bpf_jit_harden" = 2;
          "net.ipv4.tcp_syncookies" = 1;
          "net.ipv4.tcp_syn_retries" = 2;
          "net.ipv4.tcp_synack_retries" = 2;
          "net.ipv4.tcp_max_syn_backlog" = 4096;
          "net.ipv4.tcp_rfc1337" = 1;
          "net.ipv4.conf.all.log_martians" = true;
          "net.ipv4.conf.default.log_martians" = true;
        };
      })
      {
        networking.nftables.enable = true;
        networking.firewall.enable = true;
      }
    ]))
    (lib.mkIf customization.security.hardware.enable {

    })
    (lib.mkIf customization.security.kernel.enable (lib.mkMerge [
      (lib.mkIf customization.security.kernel.strong {
        boot.kernel.sysctl = {
          "kernel.yama.ptrace_scope" = 2;
          "kernel.unprivileged_bpf_disabled" = 1;
          "kernel.ftrace_enabled" = false;
          "kernel.randomize_va_space" = 2;
          "vm.unprivileged_userfaultfd" = 0;
        };
      })
      {
        security.virtualisation.flushL1DataCache = "always";
        security.forcePageTableIsolation = true;
        boot.kernel.sysctl = {
          "kernel.kptr_restrict" = 2;
          "kernel.dmesg_restrict" = 1;
        };
      }
    ]))
    (lib.mkIf customization.security.fs.enable {
      boot.kernel.sysctl = {
        "fs.suid_dumpable" = 0;
      };
    })
    (lib.mkIf customization.security.userspace.enable (lib.mkMerge [
      (lib.mkIf customization.security.userspace.strong {
          programs.firejail = {
            enable = true;
          };
      })
      {
        security.polkit.enable = true;
      }
    ]))
  ];
}