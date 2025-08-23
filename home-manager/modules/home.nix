{ config, lib, ... }:

let
  defaultFlags = config.home.defaultCommandFlags;

  fileSubmodule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether this file shall be overridden.";
      };
      mode = lib.mkOption {
        type = with lib.types; nullOr (strMatching "[[:digit:]]{3,4}");
        default = null;
        example = "0600";
        description = "Mode of the file, given in octal digits.";
      };
      sources = lib.mkOption {
        type = with lib.types; either path (listOf path);
        default = [ ];
        apply = v: if builtins.isList v then v else [ v ];
        description = "The files that will be merged into the target.";
      };
      type = lib.mkOption {
        type = lib.types.enum (lib.attrNames lib.merge);
        description = ''
          The type of the file. It determines how the sources are merged into
          the target.
        '';
      };
    };
  };

in
{

  options.home = {

    defaultCommandFlags = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          attrsOf (oneOf [
            bool
            int
            str
          ])
        );
      default = { };
      description = "Default flags for shell commands";
      example = {
        grep.binary-files = "without-match";
        ls.color = true;
        make.jobs = 4;
      };
    };

    file' = lib.mkOption {
      type = lib.types.attrsOf fileSubmodule;
      default = { };
      description = ''
        Attribute set of files that, in contrast to {option}`home.file`, not
        linked into the user home, but merged.  Thus, existing configuration
        will not be wiped but partially overridden.
      '';
    };

  };

  config = {
    home.shellAliases = lib.mapAttrs (prog: opts: "${prog} ${lib.gnuCommand.line opts}") defaultFlags;

    home.activation.mergeHomeFiles =
      let
        mkFile =
          path: spec:
          let
            targetFile = "${config.home.homeDirectory}/${path}";
          in
          ''
            run mkdir $VERBOSE_ARG -p "$(dirname '${targetFile}')"
            run touch '${targetFile}'
          ''
          + lib.merge.${spec.type} targetFile spec.sources
          + lib.optionalString (spec.mode != null) ''
            run chmod $VERBOSE_ARG ${spec.mode} ${targetFile}
          '';
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] (
        lib.concatMapAttrsStringSep "\n" mkFile config.home.file'
      );
  };

}
