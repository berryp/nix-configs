{ lib, rustPlatform, fetchgit }:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-export";
  version = "22.11.0";

  src = fetchgit {
    url = "https://github.com/zoni/obsidian-export";
    rev = "v${version}";
    sha256 = "sha256-mOr8QjuCkiw4rLQH3y/hlo+pPSZVvGyfb5vEGxW2/4g=";
  };

  cargoSha256 = "sha256-XYk7AW02Hhn6SVX6UQpZ054N1xXdQFS8XxllWMMxumY=";
}
