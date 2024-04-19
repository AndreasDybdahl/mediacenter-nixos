{ config, pkgs, ... }:

{
  imports = [ ./locale.nix ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    # Configure keymap in X11
    # layout = "no";
    # xkbVariant = "";
    # xkbOptions = "eurosign:e";

    libinput = {
      enable = true;

      # # disabling mouse acceleration
      # mouse = { accelProfile = "flat"; };

      # # touchpad settings
      # touchpad = {
      #   # accelProfile = "flat";
      #   naturalScrolling = true;
      #   disableWhileTyping = false;
      # };
    };

  };

}
