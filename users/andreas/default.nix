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
  fonts.packages = with pkgs; [
    cascadia-code
    fira-code
    fira-code-nerdfont
    fira-code-symbols

    # Chinese, Korean, and Japanese fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  home = ./home.nix;
}
