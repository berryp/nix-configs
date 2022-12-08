{ pkgs, lib, fetchurl, installShellFiles, ... }:

stdenv.mkDerivation
rec {
  pname = "awscn";
  version = "521e3621a02a8ad847cc8b844517e4079e11b697";

  doCheck = false;

  src = builtins.fetchgit {
    url = "ssh://git@github.coupang.net/coupang/awscn";
    rev = version;
    sha256 = "sha256-mOr8QjuCkiw4rLQH3y/hlo+pPSZVvGyfb5vEGxW2/4g=";
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

    install -D $out/share/bash-completion/completions awscn-completions.sh
    install -D $out/share/bash-completion/completions boltxcn-completions.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/obsidian-html/obsidian-html";
    description = "Python code to convert Obsidian notes to proper markdown and optionally to create an html site too.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ berryp ];
  };

}
