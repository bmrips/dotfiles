{ config, lib, ... }:

let
  cfg = config.programs.plasma;

  mkShortcutSchemeFor =
    let
      mkAction =
        name: value:
        let
          keys = if lib.isString value then value else lib.concatStringsSep "; " value;
        in
        /* xml */ ''<Action name="${name}" shortcut="${keys}"/>'';
    in
    app: scheme: /* xml */ ''
      <gui name="${app}" version="1">
        <ActionProperties>
          ${lib.concatStringsSep "\n    " (lib.mapAttrsToList mkAction scheme)}
        </ActionProperties>
      </gui>
    '';

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

  options.programs.plasma = {

    shortcutSchemes = lib.mkOption {
      type =
        with lib.types;
        let
          shortcut = either str (listOf str);
        in
        attrsOf (attrsOf (attrsOf shortcut));
      default = { };
      description = "Shortcut schemes.";
    };

    webSearchKeywords = {

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

  };

  config = lib.mkMerge [

    {
      xdg.dataFile = lib.concatMapAttrs (
        app:
        lib.mapAttrs' (
          name: scheme: {
            name = "${app}/shortcuts/${name}";
            value.text = mkShortcutSchemeFor app scheme;
          }
        )
      ) cfg.shortcutSchemes;
    }

    (with cfg.webSearchKeywords; {
      programs.plasma.configFile.kuriikwsfilterrc.General = {
        DefaultWebShortcut = default;
        EnableWebShortcuts = enable;
        KeywordDelimiter = delimiter;
        PreferredWebShortcuts = lib.concatStringsSep "," preferred;
        UsePreferredWebShortcutsOnly = usePreferredOnly;
      };
      assertions = lib.mapAttrsToList (attr: keyword: {
        assertion = builtins.length keyword.keys >= 1;
        message = ''
          No trigger keys are defined for the '${keyword.name}' Plasma web search keyword.
          Set it through '${
            showAttrPath [
              "programs"
              "plasma"
              "webSearchKeyword"
              attr
              "keys"
            ]
          }'.
        '';
      }) extra;
      xdg.dataFile = lib.mapAttrs' (id: keyword: {
        name = "kf6/searchproviders/${id}.desktop";
        value.text = mkWebSearchKeywordConfigFile keyword;
      }) extra;
    })

  ];

}
