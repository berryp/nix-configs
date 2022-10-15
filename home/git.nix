{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.extraConfig = {
    core.editor = "code";
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT";
    diff.colorMoved = "default";
    pull.rebase = true;
    commit.gpgsign = true;
    tag.gpgsign = true;
    gpg.format = "ssh";
    gpg.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    init.defaultBranch = "main";
  };

  programs.git.ignores = [
    ".DS_Store"
  ];

  programs.git.userEmail = config.home.user-info.email;
  programs.git.userName = config.home.user-info.fullName;

  # Enhanced diffs
  programs.git.delta.enable = true;

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
