{ lib, inputs, outputs, ... }:
{
  imports = [
    ./fish.nix
    ./nix.nix
  ];

  system.stateVersion = 4;
}
