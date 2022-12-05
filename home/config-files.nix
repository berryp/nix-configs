{ config, lib, ... }:

{
  home.file.".config/pypoetry/config.toml".text = ''
    [virtualenvs]
    in-project = true
  '';
}
