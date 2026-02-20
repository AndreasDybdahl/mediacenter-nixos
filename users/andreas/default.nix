{ pkgs, ... }:
{
  trusted = true;

  programs._1password.enable = true;

  # user.name = "notalxandr";
  user.extraGroups = [
    "wheel"
    "networkmanager"
  ];

  user.packages = with pkgs; [
    flatpak
    vlc
    zed-editor
    opencode
  ];

  home = ./home.nix;
}
