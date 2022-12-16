{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "rancher-desktop";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/rancher-sandbox/rancher-desktop/releases/download/v${version}/Rancher.Desktop-${version}.aarch64.dmg";
    sha256 = "1z7vs4jnzlyv93xbb5a262ndd8nzrg16rlv9q0ds2a5fjn8pyidd";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -R Rancher Desptop.app "$out/Applications"
  '';

  meta = with lib; {
    description = "Rancher Desktop";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ berryp ];
  };
}
