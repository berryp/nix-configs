{ config, lib, ... }:

let
  inherit (lib) mkIf;
  mkIfCaskPresent = cask: mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
  brewEnabled = config.homebrew.enable;
in
{
  homebrew.enable = true;

  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew.onActivation.autoUpdate = true;
  # homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    # "nrlquaker/createzap"
  ];

  homebrew.masApps = {
    "1Password for Safari" = 1569813296;
    # "Dark Mode for Safari" = 1397180934;
    GarageBand = 682658836;
    KakaoTalk = 869223134;
    Keynote = 409183694;
    Numbers = 409203825;
    Pages = 409201541;
    Slack = 803453959;
    Tailscale = 1475387142;
    "The Unarchiver" = 425424353;
  };

  homebrew.casks = [
    "adobe-creative-cloud"
    "appcleaner"
    "angry-ip-scanner"
    "google-chrome"
    "numi"
    "obs"
    "omnidisksweeper"
    "vlc"
  ];
}
