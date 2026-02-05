{
  description = "NixOS configuration for mediacenter PC";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "recursive-nix"
      "pipe-operators"
    ];
    trusted-users = [ "andreas" ];

    substituters = [ "https://cache.nixos.org" ];

    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    alxandr = {
      url = "github:alxandr/nix-system";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ flake-parts, alxandr, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        alxandr.flakeModules.flake-path
        alxandr.flakeModules.home-manager
        alxandr.flakeModules.disko
        alxandr.flakeModules.user-manager
        alxandr.flakeModules.systems
      ];

      config = {
        # debug = true;

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        flake.path = "github:AndreasDybdahl/mediacenter-nixos";

        systemConfigurations.sharedModules = [
          ./theme
          (
            { pkgs, ... }:
            {
              nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ];

              # Chinese, Korean, and Japanese fonts
              fonts.packages = with pkgs; [
                cascadia-code
                fira-code
                fira-code-symbols
                nerd-fonts.fira-code

                # Chinese, Korean, and Japanese fonts
                noto-fonts-cjk-sans
                noto-fonts-cjk-serif
              ];
            }
          )
        ];

        systemConfigurations.systems.mediacenter = {
          unstable = true;
          hardware = ./systems/mediacenter/hardware.nix;
          configuration = ./systems/mediacenter/configuration.nix;
          users = {
            andreas = ./users/andreas;
          };
          drives = {
            fileSystems."/" = {
              device = "/dev/disk/by-uuid/5448ffea-916b-4c16-a1d4-bc465b1bf2d6";
              fsType = "ext4";
            };

            fileSystems."/boot" = {
              device = "/dev/disk/by-uuid/14C1-9791";
              fsType = "vfat";
            };

            swapDevices = [
              { device = "/dev/disk/by-uuid/5d8a284c-cb81-4843-b297-b842e6db0b88"; }
            ];
          };
        };
      };
    };
}
