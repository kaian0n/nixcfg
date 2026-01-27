# /hosts/alns/configuration.nix
{ config, pkgs, ... }:
{
   imports = [
      ./disko-config.nix
      ./hardware-configuration.nix
   ];

   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;

   boot.supportedFilesystems = [ "zfs" "xfs" "exfat" ];
   boot.kernelModules = [ "btusb" "iwlwifi" ];
   boot.kernelPackages = pkgs.linuxPackages_latest;
   boot.zfs.package = pkgs.zfs_unstable;

   boot.extraModprobeConfig = ''
   options btusb enable_autosuspend=0
   '';

   zramSwap = {
      enable = true;
      memoryPercent = 25;
      algorithm = "zstd";
      priority = 100;
   };

   system.activationScripts.zfsAclAndXattr = ''
     set -eu
     ZFS=${config.boot.zfs.package}/bin/zfs
     if $ZFS list -H -o name tank >/dev/null 2>&1; then
       for fs in $($ZFS list -H -o name -t filesystem -r tank); do
         $ZFS set acltype=posixacl "$fs" || true
         $ZFS set xattr=sa "$fs" || true
       done
     fi
   '';

   networking.hostName = "alns";
   networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
   networking.networkmanager.enable = true;
   networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

   time.timeZone = "America/Boise";

   i18n.defaultLocale = "en_US.UTF-8";
   i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
   };

   hardware.bluetooth.enable = true;
   hardware.bluetooth.powerOnBoot = true;
   hardware.enableRedistributableFirmware = true;

   environment.systemPackages = with pkgs; [
      git
      usbutils
      pciutils
      libva-utils
      ffmpeg
   ];

   services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      allowSFTP = true;
   };

   programs.zsh.enable = true;

   system.stateVersion = "25.11";

   hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
         mesa
         libva-vdpau-driver
         libvdpau-va-gl
         vulkan-tools
      ];
   };
}
