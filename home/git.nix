{ config, pkgs, ... }:
let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT";
  email = config.home.user-info.email;
  name = config.home.user-info.fullName;
in
{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.extraConfig = {
    core.editor = "code";
    user.signingKey = signingKey;
    diff.colorMoved = "default";
    pull.rebase = true;
    commit.gpgsign = true;
    tag.gpgsign = true;
    gpg.format = "ssh";
    gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    init.defaultBranch = "main";
  };

  home.file.".ssh/allowed_signers".text = "${email} ${signingKey} ${email} ";

  programs.git.ignores = [
    ".DS_Store"
  ];

  programs.git.userEmail = email;
  programs.git.userName = name;

  # Enhanced diffs
  programs.git.delta.enable = true;

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
