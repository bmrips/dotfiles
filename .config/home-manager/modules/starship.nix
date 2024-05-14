{ lib, ... }:

with lib;

let
  format = concatMapStrings (s: "\$${s}") [
    "all"
    "fill"
    "jobs"
    "time"
    "status"
    "os"
    "container"
    "shell"
    "line_break"
    "battery"
    "character"
  ];

in {
  programs.starship.settings = {
    #:schema 'https://starship.rs/config-schema.json'
    inherit format;
    aws.symbol = " ";
    azure.symbol = " ";
    buf.symbol = " ";
    c.symbol = " ";
    conda.symbol = " ";
    container.symbol = " ";
    crystal.symbol = " ";
    dart.symbol = " ";
    directory.read_only = " 󰌾";
    directory.style = "bold blue";
    directory.truncation_length = 10;
    directory.truncate_to_repo = false;
    docker_context.symbol = " ";
    dotnet.symbol = "󰪮 ";
    elixir.symbol = " ";
    elm.symbol = " ";
    fill.symbol = " ";
    fossil_branch.symbol = " ";
    gcloud.symbol = " ";
    git_branch.symbol = " ";
    git_commit.format = "at [$hash$tag]($style) ";
    git_commit.style = "bold cyan";
    git_state.style = "bold red";
    git_status.format =
      "[($all_status )($behind$behind_count )($ahead$ahead_count )]($style)";
    git_status.style = "bold yellow";
    golang.symbol = " ";
    gradle.symbol = " ";
    guix_shell.symbol = " ";
    haskell.symbol = " ";
    haxe.symbol = " ";
    hg_branch.symbol = " ";
    hostname.ssh_symbol = " ";
    java.symbol = " ";
    jobs.number_threshold = 1;
    julia.symbol = " ";
    kotlin.symbol = " ";
    lua.symbol = " ";
    memory_usage.symbol = "󰍛 ";
    meson.symbol = "󰔷 ";
    nim.symbol = " ";
    nix_shell.symbol = " ";
    nodejs.symbol = "󰎙 ";
    ocaml.symbol = " ";
    package.symbol = "󰏗 ";
    perl.symbol = " ";
    php.symbol = "󰌟 ";
    pijul_channel.symbol = " ";
    purescript.symbol = " ";
    python.symbol = " ";
    rlang.symbol = "󰟔 ";
    ruby.symbol = "󰴭 ";
    rust.symbol = " ";
    scala.symbol = " ";
    swift.symbol = " ";
    terraform.symbol = " ";
    vlang.symbol = " ";
    zig.symbol = " ";
  };
}
