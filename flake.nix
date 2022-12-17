{
  description = "Berry's Nix system and home manager configs.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.utils.follows = "flake-utils";

    devshell.url = "github:numtide/devshell";
    dsf.url = "github:cruel-intentions/devshell-files";
    gha.url = "github:cruel-intentions/gh-actions";

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # entangled.url = "github:entangled/entangled";

    # Utility for watching macOS `defaults`.
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;

      homeStateVersion = "22.11";

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.prefmanager.overlays.prefmanager
          inputs.devshell.overlay
          (import ./pkgs)
        ] ++ singleton (
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Sub in x86 version of packages that don't build on Apple Silicon.
            # e.g. inherit (final.pkgs-x86) agda;
          })
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
      overlays = {
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
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

      darwinConfigurations = rec {
        # Minimal macOS configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefaults; } ];
        };
        bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
          system = "aarch64-darwin";
        };
        
        Berrys-iMac = makeOverridable mkDarwinSystem (primaryUserDefaults // {
          modules = attrValues self.darwinModules ++ singleton {
            nixpkgs = nixpkgsDefaults;
            networking.computerName = "Berrys iMac";
            networking.hostName = "Berrys-iMac";
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            nix.registry.my.flake = inputs.self;
          };
          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
        });

        Berrys-MBP = makeOverridable mkDarwinSystem
          (primaryUserDefaults // {
            modules = attrValues self.darwinModules ++ singleton {
              nixpkgs = nixpkgsDefaults;
              networking.computerName = "Berry's MacBookPro";
              networking.hostName = "Berrys-MBP";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
              nix.registry.my.flake = inputs.self;
            };
            inherit homeStateVersion;
            homeModules = attrValues self.homeManagerModules;
          });
      };

    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
        inherit system;
      });

      packages = with self.legacyPackages.${system}; {
        entangled = entangled;
        lmt = lmt;
        obsidian-export = obsidian-export;
        obsidianhtml = obsidianhtml;
        rancher-desktop = rancher-desktop;
        raycast = raycast;
        resilio-sync = resilio-sync;
      };

      # packages = with self.legacyPackages.${system};
      # lib.filterAttrs (n: v: builtins.elem system v.meta.platforms) {
      #   entangled = entangled;
      #   lmt = lmt;
      #   obsidian-export = obsidian-export;
      #   obsidianhtml = obsidianhtml;
      #   rancher-desktop = rancher-desktop;
      #   raycast = raycast;
      #   resilio-sync = resilio-sync;
      # };

      lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
        inherit mkDarwinSystem;
      });

      # devShells = let pkgs = self.legacyPackages.${system}; in
      #   {
      #     devops = pkgs.devshell.mkShell {
      #       name = "devops";
      #       packages = attrValues {
      #         inherit (pkgs)
      #           poetry
      #           go_1_19
      #           cue
      #           dagger
      #           kubectx
      #           kubectl
      #           k9s
      #           ;
      #       };
      #     };

      #     python = pkgs.devshell.mkShell {
      #       name = "python310";
      #       packages = attrValues {
      #         inherit (pkgs) poetry python310 pyright black isort;
      #       };
      #     };

      #     default = pkgs.devshell.mkShell {
      #       name = "Nix";
      #       packages = attrValues {
      #         inherit (pkgs)
      #           alejandra
      #           cachix
      #           deadnix
      #           nix-output-monitor
      #           nix-tree
      #           nix-update
      #           nixpkgs-review
      #           rnix-lsp
      #           statix
      #           ;
      #         # env = {
      #         #   SYSTEM = system;
      #         # };
      #         # commands = [
      #         #   {
      #         #     name = "system";
      #         #     command = "nix eval --impure --raw --expr 'builtins.currentSystem'";
      #         #   }
      #         #   # {
      #         #   #   name = "buildpkgs";
      #         #   #   command = "nix flake show --json | jq '.packages.x86_64-darwin|keys[]'| xargs -I {} nix build .#{}";
      #         #   # }
      #         #   # {
      #         #   #   name = "cacheup";
      #         #   #   command = "nix show-derivation | jq -r '.[].outputs | to_entries[].value | .[]' | cachix push berryp";
      #         #   # }
      #         # ];
      #       };
      #     };
      #   };
    });
}
