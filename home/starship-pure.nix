{
  programs.starship.settings = {
    format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";

    directory.style = "blue";

    character.success_symbol = "[❯](purple)";
    character.error_symbol = "[❯](red)";
    character.vicmd_symbol = "[❮](green)";

    git_branch.format = "[$branch]($style)";
    git_branch.style = "bright-black";

    git_status.format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
    git_status.style = "cyan";
    git_status.conflicted = "​";
    git_status.untracked = "​";
    git_status.modified = "​";
    git_status.staged = "​";
    git_status.renamed = "​";
    git_status.deleted = "​";
    git_status.stashed = "≡";

    git_state.format = "\([$state( $progress_current/$progress_total)]($style)\) ";
    git_state.style = "bright-black";

    cmd_duration.format = "[$duration]($style) ";
    cmd_duration.style = "yellow";


    python.format = "[$virtualenv]($style) ";
    python.style = "bright-black";
  };
}
