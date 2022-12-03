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
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    # aaron-bond.better-comments
    # wmaurer.change-case
    # Dagger.dagger
    # ms-vscode-remote.remote-containers
    mkhl.direnv
    ms-azuretools.vscode-docker
    mikestead.dotenv
    # dotiful.dotfiles-syntax-highlighting
    usernamehw.errorlens
    file-icons.file-icons
    # casualjim.gotemplate
    # joaompinto.vscode-graphviz
    # EFanZh.graphviz-preview
    # albymor.increment-selection
    ms-kubernetes-tools.vscode-kubernetes-tools
    yzhang.markdown-all-in-one
    bierner.markdown-mermaid
    # DavidAnson.vscode-markdownlint
    # equinusocio.vsc-material-theme-icons
    # bpruitt-goddard.mermaid-markdown-syntax-highlighting
    # pinage404.nix-extension-pack
    ms-python.python
    humao.rest-client
    stkb.rewrap
    # be5invis.toml
    redhat.vscode-yaml

    (extension {
      publisher = "jq-syntax-highlighting";
      name = "jq-syntax-highlighting";
      version = "0.0.2";
      sha256 = "sha256-Bwq+aZuDmzjHw+ZnIWlL4aGz6UnqxaKm5WUko0yuIWE=";
    })
    (extension {
      publisher = "HashiCorp";
      name = "HCL";
      version = "0.2.1";
      sha256 = "sha256-5dBLDJ7Wgv7p3DY0klqxtgo2/ckAHoMOm8G1mDOlzZc=";
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
      publisher = "ms-vscode";
      name = "makefile-tools";
      version = "0.5.0";
      sha256 = "sha256-oBYABz6qdV9g7WdHycL1LrEaYG5be3e4hlo4ILhX4KI=";
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
      publisher = "PKief";
      name = "material-icon-theme";
      version = "4.19.0";
      sha256 = "sha256-RBXs7S0iyuutUn11hFqc0VyTs4NFDFLBRvY0u8id86s=";
    })
    (extension {
      publisher = "EditorConfig";
      name = "EditorConfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
    })
  ];
  #keybindings = [];
  programs.vscode.userSettings =
    builtins.fromJSON (builtins.readFile ./../configs/vscode/settings.json);
  programs.vscode.userTasks = { };
}
