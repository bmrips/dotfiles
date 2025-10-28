{ inputs, system, ... }:

{
  programs.command-not-found.dbPath = inputs.programs-db.packages.${system}.programs-sqlite;
}
