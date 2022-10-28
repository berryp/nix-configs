{
  description = "Berry's Nix system and home manager configs.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/46e516e4434ca65e31ecb1e3df4f03c7e2fe953d";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.utils.follows = "flake-utils";

    # Other sources
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          # contentAddressedByDefault = true;
          # substituters = "https://cache.ngi0.nixos.org/";
          # trusted-public-keys = "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA=";
        };
        overlays = attrValues self.overlays ++ [
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          (final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              idris2;
          }))
        ];
      };

      homeManagerStateVersion = "22.11";

      primaryUserInfo = {
        username = "berryp";
        fullName = "Berry Phillips";
        email = "berry@berryp.xyz";
        nixConfigDirectory = "/Users/berryp/.config/nix-configs";
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;
            nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; };
            # `home-manager` config
            users.users.${primaryUser.username}.home = "/Users/${primaryUser.username}";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser.username} = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              home.user-info = config.users.primaryUser;
            };
            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          }
        )
      ];
    in
    {
      # My `nix-darwin` configs
      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        # iMac
        Berrys-iMac = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
              networking.computerName = "Berry’s iMac";
              networking.hostName = "Berrys-iMac";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
              homebrew.masApps = {
                "DaVinci Resolve" = 571213070;
              };
              homebrew.casks = [
                "hex-fiend"
                "multipass"
                "rancher"
                "spitfire-audio"
                "touchdesigner"
                "whatsapp"
              ];
              # nixpkgs.pkgs.virtualHosts."public" = {
              #   listen = [{ port = 80; addr = "0.0.0.0"; }];
              #   locations."/" = { root = "/Users/${primaryUserInfo.username}/www"; };
              # };
            }
          ];
        };

        # Personal MBP
        Berrys-MacBook-Pro = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
              networking.computerName = "Berry’s MacBook Pro";
              networking.hostName = "Berrys-MacBook-Pro";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];
        };

        # Config with small modifications needed/desired for CI with GitHub workflow
        githubCI = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ({ lib, ... }: {
              users.primaryUser = primaryUserInfo // {
                username = "runner";
                nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
              };
              homebrew.enable = lib.mkForce false;
            })
          ];
        };
      };

      # Config I use with Linux cloud VMs
      # Build and activate on new system with:
      # `nix build .#homeConfigurations.berryp.activationPackage; ./result/activate`
      homeConfigurations.berryp = home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs-unstable {
          system = "x86_64-linux";
          inherit (nixpkgsConfig) config overlays;
        };

        modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
          home.username = config.home.user-info.username;
          home.homeDirectory = "/home/${config.home.username}";
          home.stateVersion = homeManagerStateVersion;
          home.user-info = primaryUserInfo // {
            nixConfigDirectory = "${config.home.homeDirectory}/.config/nix-configs";
          };
        });
      };

      # Non-system outputs

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        prefmanager = _: prev: {
          prefmanager = inputs.prefmanager.packages.${prev.stdenv.system}.default;
        };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
      };

      darwinModules = {
        # My configurations
        berryp-bootstrap = import ./darwin/bootstrap.nix;
        berryp-defaults = import ./darwin/defaults.nix;
        berryp-general = import ./darwin/general.nix;
        berryp-homebrew = import ./darwin/homebrew.nix;

        # Custom modules by @mabob
        programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        berryp-config-files = import ./home/config-files.nix;
        berryp-fish = import ./home/fish.nix;
        berryp-zsh = import ./home/zsh.nix;
        berryp-fzf = import ./home/fzf.nix;
        berryp-shell-common = import ./home/shell-common.nix;
        berryp-git = import ./home/git.nix;
        berryp-git-aliases = import ./home/git-aliases.nix;
        berryp-gh-aliases = import ./home/gh-aliases.nix;
        berryp-neovim = import ./home/neovim.nix;
        berryp-packages = import ./home/packages.nix;
        berryp-ssh = import ./home/ssh.nix;
        berryp-starship = import ./home/starship.nix;
        berryp-starship-symbols = import ./home/starship-symbols.nix;
        berryp-starship-pure = import ./home/starship-pure.nix;

        # Custom modules
        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };


      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable
          apple-silicon
        ];
      };
    });
}
