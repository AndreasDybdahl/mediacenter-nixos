{ pkgs, lib, ... }:

{

  imports = [ ./x11.nix ./wayland.nix ./pipewire.nix ];

  services.desktopManager.plasma6.enable = lib.mkDefault true;

  services.displayManager.sddm = {
    enable = true;
    settings.Wayland.SessionDir =
      "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
  };

  programs.dconf.enable = true;

}
