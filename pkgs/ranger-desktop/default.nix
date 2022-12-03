{ lib
, stdenv
, fetchurl
, undmg
}:

stdenv.mkDerivation rec {
  pname = "rancher-desktop";
  version = "1.6.2";
  name = "Rancher Desktop";

  src = fetchurl {
    url = "https://github.com/rancher-sandbox/rancher-desktop/releases/download/v${version}/Rancher.Desktop-${version}.aarch64.dmg";
    sha256 = "1z7vs4jnzlyv93xbb5a262ndd8nzrg16rlv9q0ds2a5fjn8pyidd";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Rancher Desktop.app";

  installPhase = ''
    mkdir -p $out/Applications/$sourceRoot
    cp -R . "$out/source Root"
  '';

  meta = with lib; {
    description = "Rancher Desktop";
    # homepage = "https://www.resilio.com/";
    # sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # license = licenses.unfreeRedistributable;
    platforms = lib.platforms.darwin;
    # maintainers = [ berryp ];
  };
}
