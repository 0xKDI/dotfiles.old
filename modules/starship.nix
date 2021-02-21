{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      scan_timeout = 10;
      add_newline = false;
      character = {
        success_symbol = "[➜ ](bold green)";
        error_symbol = "[➜ ](bold red)";
        vicmd_symbol = "[V ](bold green)";
      };
      line_break.disabled = true;
      python.python_binary = "python3";
      format = [
        "username"
        "hostname"
        "shlvl"
        "kubernetes"
        "directory"
        "git_branch"
        "git_commit"
        "git_state"
        "git_status"
        # "hg_branch"
        "docker_context"
        "package"
        "cmake"
        # "dart"
        # "dotnet"
        # "elixir"
        # "elm"
        # "erlang"
        "golang"
        "helm"
        # "java"
        # "julia"
        # "nim"
        # "nodejs"
        # "ocaml"
        # "perl"
        # "php"
        # "purescript"
        "python"
        # "ruby"
        # "rust"
        # "swift"
        "terraform"
        # "zig"
        "nix_shell"
        # "conda"
        # "memory_usage"
        "aws"
        "gcloud"
        "env_var"
        # "crystal"
        "cmd_duration"
        "custom"
        "line_break"
        "jobs"
        "time"
        "status"
        "character"
      ];
    };
  };
}
