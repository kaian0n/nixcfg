# /hosts/alns/disko-config.nix
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
                     };
                  };
                  zfs = {
                     size = "100%";
                     content = {
                        type = "zfs";
                        pool = "tank";
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
                        type = "zfs";
                        pool = "tank";
                     };
                  };
               };
            };
         };
      };
      zpool = {
         tank = {
            type = "zpool";
            mode = "mirror";
            rootFsOptions = {
               compression = "lz4";
               "com.sun:auto-snapshot" = "false";
            };
            mountpoint = "/";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^tank@blank$' || zfs snapshot tank@blank";
         };
      };
   };
}
