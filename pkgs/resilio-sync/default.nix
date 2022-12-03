{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "2.7.3";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/osx/Resilio-Sync.dmg";
    sha256 = lib.fakeSha256;
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ undmg ];

  # unpackPhase = "undmg $src";

  # sourceRoot = ".";


  # installPhase = ''
  #   mkdir -p $out/Applications
  #   cp -r *.app $out/Applications
  # '';

  meta = with lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = lib.platforms.darwin;
    maintainers = with maintainers; [ berryp ];
  };
}
