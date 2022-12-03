{ config, lib, ... }:

{
  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".config/pypoetry/config.toml".text = ''
    [virtualenvs]
    in-project = true
  '';

  # Stop `parallel` from displaying citation warning
  home.file.".parallel/will-cite".text = "";
}
