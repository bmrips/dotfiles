{ config, lib, ... }:

let
  inherit (lib)
    all
    attrValues
    concatMapAttrs
    concatStringsSep
    escape
    isString
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkMerge
    mkOption
    types
    ;

  cfg = config.programs.plasma;

  mkShortcutSchemeFor =
    let
      mkAction =
        name: value:
        let
          keys = if isString value then value else concatStringsSep "; " value;
        in
        ''<Action name="${name}" shortcut="${keys}"/>'';
    in
    app: scheme: ''
      <gui name="${app}" version="1">
        <ActionProperties>
          ${concatStringsSep "\n    " (mapAttrsToList mkAction scheme)}
        </ActionProperties>
      </gui>
    '';

  webSearchKeyword = types.submodule (
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "The attribute name of this definition.";
          description = "The name of this web search keyword.";
        };
        keys = mkOption {
          type = with types; listOf str;
          default = null;
          description = "The keys that trigger this web search engine.";
        };
        query = mkOption {
          type = types.strMatching ".*\\\\\\{[@0]}.*";
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

  mkWebSearchKeywordConfigFile = keyword: ''
    [Desktop Entry]
    Charset=
    Hidden=false
    Keys=${concatStringsSep "," keyword.keys}
    Name=${keyword.name}
    Query=${escape [ "\\" ] keyword.query}
    Type=Service
  '';

in
{

  options.programs.plasma = {

    shortcutSchemes = mkOption {
      type =
        with types;
        let
          shortcut = either str (listOf str);
        in
        attrsOf (attrsOf (attrsOf shortcut));
      default = { };
      description = "Shortcut schemes.";
    };

    webSearchKeywords = {

      enable = mkEnableOption "the web search keywords plugin" // {
        default = true;
      };

      delimiter = mkOption {
        type = types.str;
        default = ":";
        description = ''
          The delimiter that separates the keyword from the search terms.
        '';
        example = "$>";
      };

      default = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          The default web search keyword that is used if no keyword was specified.
        '';
        example = "duckduckgo";
      };

      preferred = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          These web search keywords that are prioritised if there are too many results.
        '';
        example = [
          "duckduckgo"
          "wikipedia"
        ];
      };

      usePreferredOnly = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use only the preferred keywords.";
        example = true;
      };

      extra = mkOption {
        type = with types; attrsOf webSearchKeyword;
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

  config = mkMerge [

    {
      xdg.dataFile = concatMapAttrs (
        app:
        mapAttrs' (
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
        PreferredWebShortcuts = concatStringsSep "," preferred;
        UsePreferredWebShortcutsOnly = usePreferredOnly;
      };
      assertions = [
        {
          assertion = all (kw: builtins.length kw.keys >= 1) (attrValues extra);
          message = ''
            For extra web search keywords, at least one trigger key has to be defined.
          '';
        }
      ];
      xdg.dataFile = mapAttrs' (id: keyword: {
        name = "kf6/searchproviders/${id}.desktop";
        value.text = mkWebSearchKeywordConfigFile keyword;
      }) extra;
    })

  ];

}
