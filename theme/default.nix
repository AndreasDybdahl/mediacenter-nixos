{ lib, pkgs, ... }:
{
  config.stylix = {
    enable = lib.mkDefault true;
    image = ./bg.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };

  config.home-manager.sharedModules = [
    (
      { config, ... }:
      {
        # Something overwrites the default gtk2 config location, which causes home-manager
        # to fail activation. This forces the file location elsewhere such that there is no
        # conflict.
        config.gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      }
    )
  ];
}
