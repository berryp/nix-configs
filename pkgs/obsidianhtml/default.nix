{ pkgs, lib, fetchurl, ... }:

let
  inherit (pkgs.python310Packages) buildPythonPackage fetchPypi build;
in
buildPythonPackage rec {
  pname = "obsidianhtml";
  version = "3.3.0";

  src = fetchurl rec {
    url = "https://pypi.python.org/packages/source/o/obsidianhtml/obsidianhtml-${version}.tar.gz";
    sha256 = "sha256-8juasMYNIT/j6ASkAYxepG3GjFjSjVysmKW52gN1qsU=";
  };

  propagatedBuildInputs = [ build ];

  meta = with lib; {
    homepage = "https://github.com/obsidian-html/obsidian-html";
    description = "Python code to convert Obsidian notes to proper markdown and optionally to create an html site too.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ berryp ];
  };
}
