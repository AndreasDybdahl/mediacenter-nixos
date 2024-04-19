{ ... }: {
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "no";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  i18n.defaultLocale = "en_US.UTF-8";
}
