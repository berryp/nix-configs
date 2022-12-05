{
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.settings = {
    directory.truncation_length = 2;
    gcloud.disabled = true;
    hostname.style = "bold green";
    memory_usage.disabled = true;
    username.style_user = "bold blue";
    format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$nix_shell$character";
    directory.style = "blue";
    character.success_symbol = "[❯](purple)";
    character.error_symbol = "[❯](red)";
    character.vicmd_symbol = "[❮](green)";
    cmd_duration.format = "[$duration]($style) ";
    cmd_duration.style = "yellow";
  };
}
