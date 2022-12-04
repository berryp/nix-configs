{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation
rec {
  pname = "warp";
  version = "0.2022.11.29.08.03.stable_0";

  src = fetchurl {
    url = "https://warp-releases.storage.googleapis.com/stable/v${version}/Warp.dmg";
    sha256 = lib.fakeSha256;
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ undmg ];

  meta = with lib; {
    description = "The terminal for the 21st century";
    homepage = "https://www.warp.dev/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = lib.platforms.darwin;
    maintainers = with maintainers; [ berryp ];
  };
}
