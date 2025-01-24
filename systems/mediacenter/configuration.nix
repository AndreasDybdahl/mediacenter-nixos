# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Workloads
  workloads.desktop.enable = true;
  workloads.desktop.environment.plasma.enable = true;
  workloads.gaming.enable = true;

  # # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "andreas";

  # Enable flatpak
  services.flatpak.enable = true;

  # # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    libcec
  ];

  services.udev.extraRules = ''
    # Pulse8 auto attach
    SUBSYSTEM=="tty" ACTION=="add" ATTRS{manufacturer}=="Pulse-Eight" ATTRS{product}=="CEC Adapter" TAG+="systemd" ENV{SYSTEMD_WANTS}="pulse8-cec-attach@$devnode.service"

    # Force device to be reconfigured when reset after suspend, otherwise the ttyACM link is lost but udev will not notice.
    # A usb_dev_uevent with DEVNUM=000 is a sign that the device is being reset before enumeration.
    # Re-configuring causes ttyACM to be removed and re-added instead.
    SUBSYSTEM=="usb" ACTION=="change" ATTR{manufacturer}=="Pulse-Eight" ATTR{product}=="CEC Adapter" ENV{DEVNUM}=="000" ATTR{bConfigurationValue}=="1" ATTR{bConfigurationValue}="1"
  '';

  systemd.services.pulse8-cec-attach = {
    enable = true;
    description = "Configure Pulse-Eight serial device at %I";
    unitConfig = {
      ConditionPathExists = "%I";
    };
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.linuxConsoleTools}/bin/inputattach --daemon --pulse8-cec %I";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
