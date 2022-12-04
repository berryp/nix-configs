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

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";

    # Utility for watching macOS `defaults`.
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";

    berrypkgs.url = "github:berryp/nur-packages";
  };

  outputs = { self, darwin, home-manager, flake-utils, devshell, sops-nix, ... }@inputs:
    let
      inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;

      homeStateVersion = "22.11";

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.prefmanager.overlays.prefmanager
        ] ++ singleton (
          final: prev: {
            inherit (inputs.berrypkgs.${ prev.stdenv.system});
          }
        ) ++ singleton (
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Sub in x86 version of packages that don't build on Apple Silicon.
          }) // { }
        );
      };

      primaryUserDefaults = {
        username = "bephilli";
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
          makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
            username = "bephilli";
            fullName = "Berry Phillips";
            email = "berry@berryp.xyz";
            nixConfigDirectory = "/Users/berryp/.config/nix-configs";
            modules = [ ./hosts/02003A2203002XS/configuration.nix ];
            inherit homeStateVersion;
            homeModules = [
              ./hosts/02003A2203002XS/home.nix
            ];
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
      (system: {
        legacyPackages = import inputs.nixpkgs (nixpkgsDefaults // { inherit system; });

        devShells =
          let
            pkgs = self.legacyPackages.${system};
            overlays = [ devshell.overlay ];
          in
          {
            python = pkgs.devshell.mkShell {
              name = "python310";
              inputsFrom = attrValues {
                inherit (pkgs.pkgs-master.python310Packages) black isort;
                inherit (pkgs) poetry python310 pyright;
              };
            };
          };
      });
}
