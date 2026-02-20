{
  pkgs,
  lib,
  osConfig,
  ...
}:

with lib;

let
  isDesktop = osConfig.workloads.desktop.enable;

in

{
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    initExtra = ''
      alias zed="zed-editor"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode = mkIf isDesktop {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      userSettings = {
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "workbench.iconTheme" = "material-icon-theme";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        "nix.serverSettings"."nil" = {
          "formatting"."command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
          "nix"."maxMemoryMB" = 12560;
          "nix"."flake" = {
            "autoArchive" = true;
            "autoEvalInputs" = true;
          };
        };
      };
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        fill-labs.dependi
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        jnoortheen.nix-ide
        mkhl.direnv
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
      ];
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "sql"
      "html"
      "toml"
      "crates-lsp"
      "catppuccin-icons"
    ];
    extraPackages = with pkgs; [
      nixd
      rust-analyzer
    ];

    userSettings = {
      agent.enabled = true;
      agent.default_model = {
        provider = "copilot_chat";
        model = "gpt-5.3";
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      journal.hour_format = "hour24";
      auto_update = false;

      lsp.rust_analyzer.binary.path_lookup = true;
      lsp.nix.binary.path_lookup = true;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      #buffer_font_family = terminalFont;
      buffer_font_size = 16.0;
      #theme = "VSCode Dark Modern";
      #ui_font_family = terminalFont;
      ui_font_size = 16.0;
      icon_theme = "Catppuccin Latte";
    };

    #themes = {
    #  vscode-dark-modern = ./zed/themes/vscode-dark-modern.json;
    #};
  };

  home.shellAliases = {
    # Zed editor
    zed = "zeditor";
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.gh.enable = true;
  programs.gh-dash.enable = true;
  programs.git = {
    enable = true;
    extraConfig = {
      core = {
        symlinks = true;
      };

      alias = {
        wip = "commit -am 'WIP'";
      };

      color = {
        ui = "auto";
      };

      "color \"grep\"" = {
        match = "cyan bold";
        selected = "blue";
        context = "normal";
        filename = "magenta";
        linenumber = "green";
        separator = "yellow";
        function = "blue";
      };

      pretty = {
        line = "%C(auto)%h %<|(60,trunc)%s %C(green)%ad%C(auto)%d";
        detail = "%C(auto)%h %s%n  %C(yellow)by %C(blue)%an %C(magenta)<%ae> [%G?] %C(green)%ad%n %C(auto)%d%n";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        default = "upstream";
        autoSetupRemote = true;
      };

      credential = {
        helper = "cache --timeout=3600";
      };

      user = {
        useConfigOnly = true;
        name = "Andreas Dybdahl";
        email = "andreas.dyb@gmail.com";
      };

      commit = {
        gpgsign = false;
      };

      tag = {
        gpgsign = false;
      };

      http = {
        cookieFile = "~/.gitcookies";
      };
    };
    ignores = [
      # Logs and databases #
      ######################
      "*.log"
      "*.sqlite"

      # OS generated files #
      ######################
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "Icon?"
      "ehthumbs.db"
      "Thumbs.db"
    ];
  };

  home.packages = with pkgs; ([
    nixpkgs-fmt
    nixfmt-rfc-style
    nil
    nh
  ]);

  # This value determines the home-manager release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option.
  home.stateVersion = "24.05"; # Did you read the comment?
}
