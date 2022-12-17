{ mkDerivation, array, base, containers, dhall, directory, either
, exceptions, extra, filepath, fsnotify, Glob, hspec
, hspec-megaparsec, lib, megaparsec, monad-logger, mtl
, optparse-applicative, prettyprinter, prettyprinter-ansi-terminal
, QuickCheck, quickcheck-instances, regex-tdfa, rio, sqlite-simple
, terminal-size, text, time, transformers, fetchgit
}: 

mkDerivation {
  pname = "entangled";
  version = "1.4.0";
  src = fetchgit {
    url = "https://github.com/entangled/entangled";
    rev = "8f6ad5a3e3e73171253aa66fea3d54091cb55e06";
    sha256 = "1yrjxmyna6i4h77ng4sah2py9j101jzkpi3p4m5ikq5sg2qw39ck";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    array base containers dhall directory either exceptions extra
    filepath fsnotify Glob megaparsec monad-logger mtl prettyprinter
    prettyprinter-ansi-terminal regex-tdfa rio sqlite-simple
    terminal-size text time transformers
  ];
  executableHaskellDepends = [
    array base containers dhall directory either exceptions extra
    filepath fsnotify Glob megaparsec monad-logger mtl
    optparse-applicative prettyprinter prettyprinter-ansi-terminal
    regex-tdfa rio sqlite-simple terminal-size text time transformers
  ];
  testHaskellDepends = [
    array base containers dhall directory either exceptions extra
    filepath fsnotify Glob hspec hspec-megaparsec megaparsec
    monad-logger mtl prettyprinter prettyprinter-ansi-terminal
    QuickCheck quickcheck-instances regex-tdfa rio sqlite-simple
    terminal-size text time transformers
  ];
  jailbreak = true;
  doCheck = false;
  homepage = "https://entangled.github.io/";
  description = "bi-directional tangle daemon for literate programming";
  license = lib.licenses.asl20;
  mainProgram = "entangled";
}
