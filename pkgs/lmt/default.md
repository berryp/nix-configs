# Literate Markdown Tangle

lmt is a tool for extracting text from the code blocks in markdown files. It allows programmers to write in a literate programming style using markdown as the source language.

This markdown file is the source of truth for the derivation file `default.nix`.

As lmt is written in Go we will use the standard `buildGoModule` Nix expression.

This is the outline of the package derivation defined we are using:

```nix default.nix
{ lib, buildGoModule, fetchgit, ... }:

buildGoModule rec {
  <<<packageInfo>>>

  <<<source>>>

  <<<extra>>>

  <<<meta>>>
}
```

First is the basic package information for Nix. `pname` is the name of the executable
and `version` is the tag, branch or commit hash to fetch.

```nix "packageInfo"+=
pname = "lmt";
version = "251c4b0d82b96f1d0d73f4bf13593b7e235b1d06";
```

Next up we fetch the source from GitHub. We use the version variable as the revision
and we must also specify the `sha256` hash of the fetched source.

```nix "source"+=
src = fetchgit {
  url = "https://github.com/berryp/lmt.git";
  rev = version;
  sha256 = "sha256-SAoUt/aYNLeSpTfFp+FdQGd6sDCZoAe7zv3RHvHc8Vc=";
};
```

As with the source we must also supply a hash of the fetched dependencies.

```nix "extra"+=
vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
```

Finally we provide additional metadata for the Nix package.

```nix "meta"+=
meta = with lib; {
  description = "Literate Markdown Tangle";
  homepage = "https://github.com/berryp/lmt";
  license = licenses.mit;
  maintainers = with maintainers; [ berryp ];
};
```
