{ pkgs, config, lib, outputs, ... }:

{
  users.users.berryp = {
    shell = pkgs.fish;
  };

  system.activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish'';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
