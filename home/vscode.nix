{ pkgs, ... }:

let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };
in
{
  programs.vscode.enable = true;

  programs.vscode.enableUpdateCheck = false;
  programs.vscode.enableExtensionUpdateCheck = false;

  programs.vscode.mutableExtensionsDir = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    mkhl.direnv
    mikestead.dotenv
    usernamehw.errorlens
    file-icons.file-icons
    yzhang.markdown-all-in-one
    bierner.markdown-mermaid
    ms-python.python
    humao.rest-client
    stkb.rewrap
    alefragnani.project-manager
    hashicorp.terraform

    # redhat.vscode-yaml

    # TODO: Need to find alternatives or add derivations for missing vscode extensions
    # be5invis.toml
    # DavidAnson.vscode-markdownlint
    # albymor.increment-selection
    # aaron-bond.better-comments
    # wmaurer.change-case
    # ms-vscode-remote.remote-containers

    (extension {
      publisher = "jq-syntax-highlighting";
      name = "jq-syntax-highlighting";
      version = "0.0.2";
      sha256 = "sha256-Bwq+aZuDmzjHw+ZnIWlL4aGz6UnqxaKm5WUko0yuIWE=";
    })
    (extension {
      publisher = "HashiCorp";
      name = "terraform";
      version = "2.23.0";
      sha256 = "sha256-3v2hEf/cEd7NiXfk7eJbmmdyiQJ7bWl9TuaN+y5k+e0=";
    })
    (extension {
      publisher = "vstirbu";
      name = "vscode-mermaid-preview";
      version = "1.6.3";
      sha256 = "sha256-rFYXFxzqtk2fUPbpijlQBbRdtW7bkAOxthUTzAkaYBk=";
    })
    (extension {
      publisher = "dzhavat";
      name = "bracket-pair-toggler";
      version = "0.0.2";
      sha256 = "sha256-2u+bdXU9nU1C8X3hpi7FfI2en4mlgWRPIVzcZrgGzPo=";
    })
    (extension {
      publisher = "golang";
      name = "Go";
      version = "0.35.1";
      sha256 = "sha256-MHQrFxqSkcpQXiZQoK8e+xVgRjl3Db3n72hrQrT98lg=";
    })
    (extension {
      publisher = "jallen7usa";
      name = "vscode-cue-fmt";
      version = "0.1.1";
      sha256 = "sha256-juOcZgSfhM1BnyVQPleP86rbuRt0peGIr2aDh7WmNQk=";
    })
    (extension {
      publisher = "nickgo";
      name = "cuelang";
      version = "0.0.1";
      sha256 = "sha256-dAMV1SQUSuq2nze5us6/x1DGYvxzFz3021++ffQoafI=";
    })
    (extension {
      publisher = "bufbuild";
      name = "vscode-buf";
      version = "0.5.0";
      sha256 = "sha256-ePvmHgb6Vdpq1oHcqZcfVT4c/XYZqxJ6FGVuKAbQOCg=";
    })
    (extension {
      publisher = "EditorConfig";
      name = "EditorConfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
    })
  ];

  programs.vscode.userSettings = {
    "editor.fontFamily" = "Fira Code";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 14;
    "editor.formatOnPaste" = true;
    "editor.formatOnSave" = true;
    "editor.rulers" = [ 80 100 ];
    "search.exclude" = {
      "**/.direnv" = true;
      "**/.git" = true;
      "*.lock" = true;
    };
    "terminal.integrated.fontFamily" = "FiraCode Nerd Font Mono";
    "terminal.external.osxExec" = "Terminal.app";
    "nix.enableLanguageServer" = true;
    "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
    "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
    "projectManager.showProjectNameInStatusBar" = true;
    "projectManager.vscode.baseFolders" = [ "$HOME/Code" "$HOME/git" "$HOME/.config/.nix-configs" ];
    "extensions.autoCheckUpdates" = false;

    "redhat.telemetry.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "terminal.integrated.profiles.osx" = {
      "fish (login)" = {
        path = "${pkgs.fish}/bin/fish";
        args = [ "-l" ];
      };
    };
    "terminal.integrated.profiles.linux" = {
      "fish (login)" = {
        path = "${pkgs.fish}/bin/fish";
        args = [ "-l" ];
      };
    };
    "extensions.ignoreRecommendations" = true;
    "terminal.integrated.defaultProfile.osx" = "fish (login)";
    "terminal.integrated.automationProfile.osx" = {
      path = "${pkgs.bash}/bin/bash";
    };
    "terminal.integrated.defaultProfile.linux" = "fish (login)";
    "terminal.integrated.automationProfile.linux" = {
      path = "${pkgs.bash}/bin/bash";
    };
    "workbench.iconTheme" = "file-icons";
    "workbench.startupEditor" = "none";
    "projectManager.git.baseFolders" = [
      "~/Code"
      "~/.config/nix-configs"
      "~/git"
    ];

  };

  programs.vscode.userTasks = { };
}
