{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "lmt";
  version = "251c4b0d82b96f1d0d73f4bf13593b7e235b1d06";

  src = fetchgit {
    url = "https://github.com/berryp/lmt.git";
    rev = version;
    sha256 = "sha256-SAoUt/aYNLeSpTfFp+FdQGd6sDCZoAe7zv3RHvHc8Vc=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "Literate Markdown Tangle";
    homepage = "https://github.com/berryp/lmt";
    license = licenses.mit;
    maintainers = with maintainers; [ berryp ];
  };
}
