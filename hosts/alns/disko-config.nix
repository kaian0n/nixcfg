{
  disko.devices = {
    disk = {
      nvme0 = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "luks";
                name = "tank-nvme0";
                extraFormatArgs = [ "--type" "luks2" ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
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
                name = "tank-nvme1";
                extraFormatArgs = [ "--type" "luks2" ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      sda = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data";
              };
            };
          };
        };
      };
    };
    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";  # Changed: enables mirroring across nvme0 and nvme1
        rootFsOptions = {
          compression = "lz4";
          acltype = "posix";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^tank@blank$' || zfs snapshot tank@blank";
      };
    };
  };
}
