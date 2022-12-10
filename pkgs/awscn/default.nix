{ stdenv, pkgs, lib, fetchurl, installShellFiles, ... }:

stdenv.mkDerivation
rec {
  pname = "awscn";
  version = "22";

  doCheck = false;

  src = builtins.fetchGit {
    url = "ssh://git@github.coupang.net/sre/awscn";
    rev = "b60fea21551b45ddfadf6f0c3ce4431a8f753b56";
    ref = "refs/heads/sre-subnets";
  };

  buildInputs = [ pkgs.jq ];

  postPatch = ''
    for f in {awscn,boltxcn}; do
      substituteInPlace $f \
        --replace " jq " " ${pkgs.jq}/bin/jq "
    done
  '';

  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    mkdir -p $out/bin
    cp awscn boltxcn $out/bin

  '';
  # install -D $out/share/bash-completion/completions awscn-completions.sh
  # install -D $out/share/bash-completion/completions boltxcn-completions.sh

  meta = with lib; {
    homepage = "https://github.com/obsidian-html/obsidian-html";
    description = "Python code to convert Obsidian notes to proper markdown and optionally to create an html site too.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ berryp ];
  };

}

