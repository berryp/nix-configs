{
  description = "Berry's Nix system and home manager configs.";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.utils.follows = "flake-utils";

    devshell.url = "github:numtide/devshell";

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    entangled.url = "github:entangled/entangled";

    # Utility for watching macOS `defaults`.
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;

      homeStateVersion = "22.11";

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.prefmanager.overlays.prefmanager
          (import ./pkgs)
        ] ++ singleton (
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Sub in x86 version of packages that don't build on Apple Silicon.
            # e.g. inherit (final.pkgs-x86) agda;
          }) // { }
        );
      };

      primaryUserDefaults = {
        username = "berryp";
        fullName = "Berry Phillips";
        email = "berry@berryp.xyz";
        nixConfigDirectory = "/Users/berryp/.config/nix-configs";
      };
    in
    {
      # Add some additional functions to `lib`.
      lib = inputs.nixpkgs.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
      });

      overlays = {
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs {
            system = "x86_64-darwin";
            inherit (nixpkgsDefaults) config;
          };
        };
      };

      darwinModules = {
        # My configurations
        berryp-bootstrap = import ./darwin/bootstrap.nix;
        berryp-defaults = import ./darwin/defaults.nix;
        berryp-general = import ./darwin/general.nix;
        berryp-homebrew = import ./darwin/homebrew.nix;

        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        berryp-config-files = import ./home/config-files.nix;
        berryp-fish = import ./home/fish.nix;
        berryp-fzf = import ./home/fzf.nix;
        berryp-git-aliases = import ./home/git-aliases.nix;
        berryp-gh-aliases = import ./home/gh-aliases.nix;
        berryp-git = import ./home/git.nix;
        berryp-packages = import ./home/packages.nix;
        berryp-starship = import ./home/starship.nix;
        berryp-ssh = import ./home/ssh.nix;
        berryp-vscode = import ./home/vscode.nix;
        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };

      # My `nix-darwin` configs
      darwinConfigurations = rec {
        # # My Intel iMac config
        # Berrys-iMac = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
        #   modules = attrValues self.darwinModules ++ singleton {
        #     nixpkgs = nixpkgsDefaults;
        #     networking.computerName = "Berry’s iMac";
        #     networking.hostName = "Berrys-iMac";
        #     networking.knownNetworkServices = [
        #       "Wi-Fi"
        #       "USB 10/100/1000 LAN"
        #     ];
        #     nix.registry.my.flake = inputs.self;
        #   };
        #   inherit homeStateVersion;
        #   homeModules = attrValues self.homeManagerModules;
        # });

        # # My Intel MacBookPro
        # Berrys-MBP = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
        #   modules = attrValues self.darwinModules ++ singleton {
        #     nixpkgs = nixpkgsDefaults;
        #     networking.computerName = "Berry’s MacBook Pro";
        #     networking.hostName = "Berrys-MacBook-Pro";
        #     networking.knownNetworkServices = [
        #       "Wi-Fi"
        #       "USB 10/100/1000 LAN"
        #     ];
        #     nix.registry.my.flake = inputs.self;
        #   };
        #   inherit homeStateVersion;
        #   homeModules = attrValues self.homeManagerModules;
        # });

        # My Work Silicon MacBookPro
        "02003A2203002XS" =
          makeOverridable self.lib.mkDarwinSystem ({
            username = "bephilli";
            fullName = "Berry Phillips";
            email = "bephilli@coupang.com";
            nixConfigDirectory = "/Users/bephilli/.config/nix-configs";
          } // {
            modules = attrValues self.darwinModules ++ singleton {
              # networking.knownNetworkServices = [
              #   "Wi-Fi"
              #   "Belkin USB-C LAN"
              # ];

              nixpkgs = nixpkgsDefaults;
              nix.registry.my.flake = inputs.self;
            } ++ [
              ./hosts/02003A2203002XS/darwin.nix
            ];

            inherit homeStateVersion;
            homeModules = attrValues self.homeManagerModules ++ [ ./hosts/02003A2203002XS/home.nix ];
          });
      };

      # homeConfigurations.berryp = home-manager.lib.homeManagerConfiguration
      #   {
      #     pkgs = import inputs.nixpkgs (nixpkgsDefaults // { system = "x86_64-linux"; });
      #     modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
      #       home.username = config.home.user-info.username;
      #       home.homeDirectory = "/home/${config.home.username}";
      #       home.stateVersion = homeStateVersion;
      #       home.user-info = primaryUserDefaults // {
      #         nixConfigDirectory = "${config.home.homeDirectory}/.config/nixpkgs";
      #       };
      #     });
      #   };
    } // flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs (nixpkgsDefaults // {
            inherit system;
            overlays = [ inputs.devshell.overlay ];
          });
        in
        {


          devShells = {
            devops = pkgs.devshell.mkShell {
              name = "devops";
              packages = attrValues {
                inherit (pkgs)
                  poetry
                  go_1_19
                  cue
                  dagger
                  kubectx
                  kubectl
                  k9s
                  ;
              };
            };

            python = pkgs.devshell.mkShell {
              name = "python310";
              packages = attrValues {
                inherit (pkgs) poetry python310 pyright black isort;
              };
            };

            default = pkgs.devshell.mkShell {
              name = "Nix";
              packages = attrValues {
                inherit (pkgs)
                  alejandra
                  cachix
                  nix-output-monitor
                  nix-tree
                  nix-update
                  nixpkgs-review
                  rnix-lsp
                  statix
                  ;
              };
              commands = [
                {
                  command = "nix build .#darwinConfigurations.$hostname.system";
                  name = "build";
                  help = "Build work Flake";
                }
              ];
            };
          };
        });
}
