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
  ];

  # Chinese, Korean, and Japanese fonts
  config.fonts.packages = [
    pkgs.cascadia-code
    pkgs.fira-code
    pkgs.fira-code-nerdfont
    pkgs.fira-code-symbols

    # Chinese, Korean, and Japanese fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
  ];

  home = ./home.nix;
}
