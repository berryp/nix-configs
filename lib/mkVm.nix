inputs:

{ username
, fullName
, email
, nixConfigDirectory
, system ? "x86_64-darwin"
, format ? "qcow"

  # `nix-darwin` modules to include
, modules ? [ ]
  # Additional `nix-darwin` modules to include, useful when reusing a configuration with
  # `lib.makeOverridable`.
, extraModules ? [ ]

  # Value for `home-manager`'s `home.stateVersion` option.
, homeStateVersion
  # `home-manager` modules to include
, homeModules ? [ ]
  # Additional `home-manager` modules to include, useful when reusing a configuration with
  # `lib.makeOverridable`.
, extraHomeModules ? [ ]
}:

inputs.nixos-generators.nixosGenerate {
  inherit system;
  inherit format;
  modules = modules ++ extraModules ++ [
    ../users/${username}/nixos.nix
    inputs.home-manager.nixosModules.home-manager
    ({ config, ... }: {
      users.primaryUser = { inherit username fullName email nixConfigDirectory; };

      # `home-manager` config
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        imports = homeModules ++ extraHomeModules;
        home.stateVersion = homeStateVersion;
        home.user-info = config.users.primaryUser;
      };
    })
  ];
}
