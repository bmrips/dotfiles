{ config, lib, ... }:

let
  cfg = config.programs.plasma.webSearchKeywords;

  webSearchKeyword = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          defaultText = "<name>";
          description = "The name of this web search keyword.";
        };
        keys = lib.mkOption {
          type = with lib.types; listOf str;
          default = null;
          description = "The keys that trigger this web search engine.";
        };
        query = lib.mkOption {
          type = lib.types.strMatching ".*\\\\\\{[@0]}.*";
          default = null;
          description = ''
            The URI that is used to perform the search on the search engine here.

            The whole text to be searched for can be specified as `\{@}` or `\{0}`. Recommended is `\{@}`, since it removes all query variables (`key=value` pairs) from the resulting string, whereas `\{0}` will be substituted with the unmodified query string.

            You can use `\{1}...\{n}` to specify certain words from the query and `\{key}` to specify a value given by `key=value` in the user query.

            In addition it is possible to specify multiple references (keys, numbers and strings) at once, i.e. `\{1,key,...,"default"}`. The first matching value (from the left) will be used as the substitution value for the resulting URI. A quoted string can be used as the default value if nothing matches from the left of the reference list.
          '';
        };
      };
    }
  );

  mkWebSearchKeywordConfigFile = keyword: /* desktop */ ''
    [Desktop Entry]
    Charset=
    Hidden=false
    Keys=${lib.concatStringsSep "," keyword.keys}
    Name=${keyword.name}
    Query=${lib.escape [ "\\" ] keyword.query}
    Type=Service
  '';

in
{

  options.programs.plasma.webSearchKeywords = {

    enable = lib.mkEnableOption "the web search keywords plugin." // {
      default = true;
    };

    delimiter = lib.mkOption {
      type = lib.types.str;
      default = ":";
      description = ''
        The delimiter that separates the keyword from the search terms.
      '';
      example = "$>";
    };

    default = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        The default web search keyword that is used if no keyword was specified.
      '';
      example = "duckduckgo";
    };

    preferred = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        These web search keywords that are prioritised if there are too many results.
      '';
      example = [
        "duckduckgo"
        "wikipedia"
      ];
    };

    usePreferredOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to use only the preferred keywords.";
      example = true;
    };

    extra = lib.mkOption {
      type = with lib.types; attrsOf webSearchKeyword;
      default = { };
      description = "Extra keywords to be added.";
      example = {
        nixpkgs = {
          keys = [
            "np"
            "nixpkgs"
          ];
          query = "https://search.nixos.org/packages?channel=unstable&query=\\{@}";
        };
      };
    };

  };

  config = {
    assertions = lib.mapAttrsToList (attr: keyword: {
      assertion = builtins.length keyword.keys >= 1;
      message = ''
        No trigger keys are defined for the '${keyword.name}' Plasma web search keyword.
        Set it through '${
          lib.options.showOption [
            "programs"
            "plasma"
            "webSearchKeyword"
            attr
            "keys"
          ]
        }'.
      '';
    }) cfg.extra;

    programs.plasma.configFile.kuriikwsfilterrc.General = {
      DefaultWebShortcut = cfg.default;
      EnableWebShortcuts = cfg.enable;
      KeywordDelimiter = cfg.delimiter;
      PreferredWebShortcuts = lib.concatStringsSep "," cfg.preferred;
      UsePreferredWebShortcutsOnly = cfg.usePreferredOnly;
    };

    xdg.dataFile = lib.mapAttrs' (id: keyword: {
      name = "kf6/searchproviders/${id}.desktop";
      value.text = mkWebSearchKeywordConfigFile keyword;
    }) cfg.extra;
  };

}
