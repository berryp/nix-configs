{ config, pkgs, ... }:

let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT";
in
{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix

  home.file.".ssh/allowed_signers".text =
    "* ${signingKey}";

  programs.git = {
    enable = true;

    userEmail = config.home.user-info.email;
    userName = config.home.user-info.fullName;

    extraConfig = {
      diff.colorMoved = "default";
      pull.rebase = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh = {
        allowedSignersFile = "~/.ssh/allowed_signers";
        program = "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign";        
      };
      user.signingkey = signingKey;
    };

    ignores = [
      ".DS_Store"
    ];

    # Enhanced diffs
    delta.enable = true;
  };

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
