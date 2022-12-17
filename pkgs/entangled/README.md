Must run `nix run nixpkgs#cabal2nix -- --no-check --jailbreak .` from source to get updated expression. Then add an import for `fetchgit` and replace `src = "."` with:

```nix
fetchgit {
  url = "https://github.com/entangled/entangled";
  rev = "<revision";
  sha256 = "1yrjxmyna6i4h77ng4sah2py9j101jzkpi3p4m5ikq5sg2qw39ck";
}
```

Change the `sha256` once you see the sha error.