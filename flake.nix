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

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # Utility for watching macOS `defaults`.
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";

    berrypkgs.url = "github:berryp/nur-packages";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;

      homeStateVersion = "22.11";

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays = attrValues self.overlays ++ [
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
      lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
      });

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
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
        # berryp-homebrew = import ./darwin/homebrew.nix;

        # Custom modules
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

      # My `nix-darwin` configs
      darwinConfigurations = rec {
        # Minimal macOS configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefaults; } ];
        };
        bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
          system = "aarch64-darwin";
        };

        # My Intel iMac config
        Berrys-iMac = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
          modules = attrValues self.darwinModules ++ singleton {
            nixpkgs = nixpkgsDefaults;
            networking.computerName = "Berry’s iMac";
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

        # My Intel MacBookPro
        Berrys-MBP = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
          modules = attrValues self.darwinModules ++ singleton {
            nixpkgs = nixpkgsDefaults;
            networking.computerName = "Berry’s MacBook Pro";
            networking.hostName = "Berrys-MacBook-Pro";
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            nix.registry.my.flake = inputs.self;
          };
          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
        });

        # My Work Silicon MacBookPro
        "02003A2203002XS" =
          let
            username = "bephilli";
            email = "bephilli@coupang.com";
            pkgs = import inputs.nixpkgs-unstable { system = "aarch64-darwin"; };
          in
          self.darwinConfigurations.Berrys-MBP.override
            {
              username = username;
              fullName = "Berry Phillips";
              email = email;
              nixConfigDirectory = "/Users/bephilli/.config/nixpkgs";
              extraModules = singleton { homebrew.enable = self.lib.mkForce false; };
              modules = attrValues self.darwinModules ++ singleton {
                nix.registry.my.flake = inputs.self;
                security.pam.enableSudoTouchIdAuth = self.lib.mkForce false;
                launchd.envVariables.HTTPS_PROXY = "http://172.29.8.195:8888";
                security.pki.certificates = [
                  ''
                    -----BEGIN CERTIFICATE-----
                    MIIE0zCCA7ugAwIBAgIJANu+mC2Jt3uTMA0GCSqGSIb3DQEBCwUAMIGhMQswCQYD
                    VQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8GA1UEBxMIU2FuIEpvc2Ux
                    FTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMMWnNjYWxlciBJbmMuMRgw
                    FgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG9w0BCQEWE3N1cHBvcnRA
                    enNjYWxlci5jb20wHhcNMTQxMjE5MDAyNzU1WhcNNDIwNTA2MDAyNzU1WjCBoTEL
                    MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExETAPBgNVBAcTCFNhbiBK
                    b3NlMRUwEwYDVQQKEwxac2NhbGVyIEluYy4xFTATBgNVBAsTDFpzY2FsZXIgSW5j
                    LjEYMBYGA1UEAxMPWnNjYWxlciBSb290IENBMSIwIAYJKoZIhvcNAQkBFhNzdXBw
                    b3J0QHpzY2FsZXIuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
                    qT7STSxZRTgEFFf6doHajSc1vk5jmzmM6BWuOo044EsaTc9eVEV/HjH/1DWzZtcr
                    fTj+ni205apMTlKBW3UYR+lyLHQ9FoZiDXYXK8poKSV5+Tm0Vls/5Kb8mkhVVqv7
                    LgYEmvEY7HPY+i1nEGZCa46ZXCOohJ0mBEtB9JVlpDIO+nN0hUMAYYdZ1KZWCMNf
                    5J/aTZiShsorN2A38iSOhdd+mcRM4iNL3gsLu99XhKnRqKoHeH83lVdfu1XBeoQz
                    z5V6gA3kbRvhDwoIlTBeMa5l4yRdJAfdpkbFzqiwSgNdhbxTHnYYorDzKfr2rEFM
                    dsMU0DHdeAZf711+1CunuQIDAQABo4IBCjCCAQYwHQYDVR0OBBYEFLm33UrNww4M
                    hp1d3+wcBGnFTpjfMIHWBgNVHSMEgc4wgcuAFLm33UrNww4Mhp1d3+wcBGnFTpjf
                    oYGnpIGkMIGhMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8G
                    A1UEBxMIU2FuIEpvc2UxFTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMM
                    WnNjYWxlciBJbmMuMRgwFgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG
                    9w0BCQEWE3N1cHBvcnRAenNjYWxlci5jb22CCQDbvpgtibd7kzAMBgNVHRMEBTAD
                    AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAw0NdJh8w3NsJu4KHuVZUrmZgIohnTm0j+
                    RTmYQ9IKA/pvxAcA6K1i/LO+Bt+tCX+C0yxqB8qzuo+4vAzoY5JEBhyhBhf1uK+P
                    /WVWFZN/+hTgpSbZgzUEnWQG2gOVd24msex+0Sr7hyr9vn6OueH+jj+vCMiAm5+u
                    kd7lLvJsBu3AO3jGWVLyPkS3i6Gf+rwAp1OsRrv3WnbkYcFf9xjuaf4z0hRCrLN2
                    xFNjavxrHmsH8jPHVvgc1VD0Opja0l/BRVauTrUaoW6tE+wFG5rEcPGS80jjHK4S
                    pB5iDj2mUZH1T8lzYtuZy0ZPirxmtsk3135+CKNa2OCAhhFjE0xd
                    -----END CERTIFICATE-----
                  ''
                  (builtins.readFile "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt")
                ];
              };
              inherit homeStateVersion;
              homeModules = attrValues self.homeManagerModules ++ singleton {
                programs.git.userEmail = email;
                programs.git.extraConfig.https.proxy = "
                  http://172.29.8.195:8888
                  ";
                programs.ssh.enable = true;
                programs.ssh.matchBlocks = {
                  "dev" = {
                    hostname = "aws-gw-dev.coupang.net";
                  };

                  "prod" = {
                    hostname = "aws-gw.coupang.net";
                  };

                  "dev-boltx" = {
                    hostname = "boltx-jumpbox-dev.coupang.net";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p dev";
                    };
                  };

                  "prod-boltx" = {
                    hostname = "boltx-jumpbox-prod.coupang.net";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "SG_PROVISIONER" = {
                    hostname = "10.111.171.55";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "SG_TEST" = {
                    hostname = "10.111.171.55";
                    extraOptions = {
                      ProxyJump = "daroche@prod";
                    };
                  };

                  "TW_PROVISIONER" = {
                    hostname = "10.232.11.85";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "TW_MONGO" = {
                    hostname = "10.232.69.149";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "KR_MONGO" = {
                    hostname = "10.219.104.36";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "KR_PROVISIONER" = {
                    hostname = "10.238.23.169";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "CIRCLECI" = {
                    hostname = "10.224.174.163";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "EMRTEST" = {
                    hostname = "10.213.207.153";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p dev";
                    };
                  };

                  "OEBOLTX" = {
                    hostname = "10.219.65.22";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };

                  "prod_prov" = {
                    hostname = "10.236.109.107";
                    extraOptions = {
                      ProxyCommand = "ssh -q -W %h:%p prod";
                    };
                  };
                };
              };
            };
      };

      # Config with small modifications needed/desired for CI with GitHub workflow
      githubCI = self.darwinConfigurations.Berrys-MBP.override
        {
          system = "x86_64-darwin";
          username = "runner";
          nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
          extraModules = singleton { homebrew.enable = self.lib.mkForce false; };
        };

      # Config I use with non-NixOS Linux systems (e.g., cloud VMs etc.)
      # Build and activate on new system with:
      # `nix build .#homeConfigurations.berryp.activationPackage && ./result/activate`
      homeConfigurations.berryp = home-manager.lib.homeManagerConfiguration
        {
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // { system = "x86_64-linux"; });
          modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
            home.username = config.home.user-info.username;
            home.homeDirectory = "/home/${config.home.username}";
            home.stateVersion = homeStateVersion;
            home.user-info = primaryUserDefaults // {
              nixConfigDirectory = "${config.home.homeDirectory}/.config/nixpkgs";
            };
          });
        };
    } // flake-utils.lib.eachDefaultSystem
      (system: {
        # Re-export `nixpkgs-unstable` with overlays.
        # This is handy in combination with setting `nix.registry.my.flake = inputs.self`.
        # Allows doing things like `nix run my#prefmanager -- watch --all`
        legacyPackages = import inputs.nixpkgs-unstable (nixpkgsDefaults // { inherit system; });

        # Development shells ----------------------------------------------------------------------{{{
        # Shell environments for development
        # With `nix.registry.my.flake = inputs.self`, development shells can be created by running,
        # e.g., `nix develop my#python`.
        devShells = let pkgs = self.legacyPackages.${system}; in
          {
            python = pkgs.mkShell {
              name = "python310";
              inputsFrom = attrValues {
                inherit (pkgs.pkgs-master.python310Packages) black isort;
                inherit (pkgs) poetry python310 pyright;
              };
            };
          };
      });
}
