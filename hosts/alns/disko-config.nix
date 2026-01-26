# /hosts/alns/disko-config.nix
#
# Disk layout:
#   - nvme0n1 + nvme1n1: LUKS-encrypted ZFS mirror pool "tank" (root filesystem)
#   - sda: XFS formatted HDD for Jellyfin media storage
#
{
  disko.devices = {
    disk = {
      # ──────────────────────────────────────────────────────────────
      # NVMe 0 - Boot partition + first half of ZFS mirror
      # ──────────────────────────────────────────────────────────────
      nvme0 = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot0";
                askPassword = true;
                settings = {
                  allowDiscards = true;
                };
                extraFormatArgs = [
                  "--type" "luks2"
                  "--cipher" "aes-xts-plain64"
                  "--key-size" "512"
                  "--hash" "sha256"
                  "--iter-time" "5000"
                  "--pbkdf" "argon2id"
                ];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

      # ──────────────────────────────────────────────────────────────
      # NVMe 1 - Second half of ZFS mirror (no boot partition needed)
      # ──────────────────────────────────────────────────────────────
      nvme1 = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot1";
                askPassword = true;
                settings = {
                  allowDiscards = true;
                };
                extraFormatArgs = [
                  "--type" "luks2"
                  "--cipher" "aes-xts-plain64"
                  "--key-size" "512"
                  "--hash" "sha256"
                  "--iter-time" "5000"
                  "--pbkdf" "argon2id"
                ];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

      # ──────────────────────────────────────────────────────────────
      # HDD - XFS for Jellyfin media storage
      # XFS excels at large file I/O (streaming .mkv files)
      # ──────────────────────────────────────────────────────────────
      sda = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            media = {
              name = "media";
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/media";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "nodiratime"
                ];
              };
            };
          };
        };
      };
    };

    # ──────────────────────────────────────────────────────────────
    # ZFS Pool - Mirrored across both NVMe drives
    # ──────────────────────────────────────────────────────────────
    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        mountpoint = null;

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
            };
          };

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              compression = "zstd";
              atime = "off";
            };
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              compression = "zstd";
              "com.sun:auto-snapshot" = "true";
            };
          };

          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              mountpoint = "legacy";
              compression = "zstd";
              "com.sun:auto-snapshot" = "true";
            };
          };

          var = {
            type = "zfs_fs";
            mountpoint = "/var";
            options = {
              mountpoint = "legacy";
              compression = "zstd";
            };
          };

          reserved = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              refreservation = "10G";
            };
          };
        };

        postCreateHook = ''
          zfs snapshot tank/root@blank
          zfs snapshot tank/home@initial
        '';
      };
    };
  };
}
