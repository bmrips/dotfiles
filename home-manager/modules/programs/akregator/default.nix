{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.akregator;

  feed =
    { name, ... }:
    {
      options = {
        archiving = {
          mode = lib.mkOption {
            description = "The archiving mode for this feed.";
            example = "keepAllArticles";
            default = "globalDefault";
            type = lib.types.enum [
              "globalDefault"
              "keepAllArticles"
              "limitArticleNumber"
              "limitArticleAge"
              "disableArchiving"
            ];
          };
          maxArticleAge = lib.mkOption {
            description = "The maximum age of articles to be kept (in days).";
            example = "60";
            type = lib.types.ints.positive;
          };
          maxArticleNumber = lib.mkOption {
            description = "The maximum number of articles to keep.";
            example = "1000";
            type = lib.types.ints.positive;
          };
        };
        comment = lib.mkOption {
          description = "A comment attached to this feed.";
          default = null;
          type = with lib.types; nullOr str;
        };
        description = lib.mkOption {
          description = "Description of this feed.";
          example = "Recent content on KDE Blogs";
          default = null;
          type = with lib.types; nullOr str;
        };
        homepage = lib.mkOption {
          description = ''
            The homepage of this feed.

            Corresponds to the `htmlUrl` field.
          '';
          example = "https://blogs.kde.org/";
          type = lib.types.str;
        };
        loadFullWebsite = lib.mkOption {
          description = ''
            Whether to load the full website when viewing an article.

            Corresponds to the `loadLinkedWebsite` field.
          '';
          example = true;
          default = null;
          type = with lib.types; nullOr bool;
        };
        markImmediatelyAsRead = lib.mkOption {
          description = "Whether to mark articles as read on arrival.";
          example = true;
          default = null;
          type = with lib.types; nullOr bool;
        };
        name = lib.mkOption {
          description = "The name of the feed. This determines the `text` and `title` fields.";
          example = "KDE Blogs";
          default = name;
          defaultText = lib.literalExpression "<name>";
          type = lib.types.str;
        };
        notify = lib.mkOption {
          description = ''
            Whether to send a notification on article arrival.

            Corresponds to the `useNotification` field.
          '';
          example = true;
          default = null;
          type = with lib.types; nullOr bool;
        };
        type = lib.mkOption {
          description = ''
            The type of this feed.

            Corresponds to the `type` and `version` fields.
          '';
          type = lib.types.enum [
            "RSS"
            "Atom"
          ];
        };
        updateInterval = lib.mkOption {
          description = ''
            The interval (in minutes) with which the feed is updated. Set to `null`
            to use the global default.

            Corresponds to the `useCustomFetchInterval` and `fetchInterval` fields.
          '';
          example = "60";
          default = null;
          type = with lib.types; nullOr ints.positive;
        };
        url = lib.mkOption {
          description = ''
            The URL from where to fetch the feed.

            Corresponds to the `xmlUrl` field.
          '';
          example = "https://blogs.kde.org/index.xml";
          type = lib.types.str;
        };
      };
    };

  mkFeed =
    feed:
    let
      setIfNonNull =
        attribute: value:
        let
          sanitizedValue =
            if lib.isString value then
              value
            else if lib.isBool value then
              lib.boolToString value
            else
              abort "expected string or bool but got ${builtins.typeOf value}: ${toString value}";
        in
        lib.optionalAttrs (value != null) {
          ${attribute} = sanitizedValue;
        };
    in
    {
      "@archiveMode" = feed.archiving.mode;
      "@htmlUrl" = feed.homepage;
      "@text" = feed.name;
      "@title" = feed.name;
      "@type" = lib.toLower feed.type;
      "@useCustomFetchInterval" = feed.updateInterval != null;
      "@version" = feed.type;
      "@xmlUrl" = feed.url;
    }
    // lib.optionalAttrs (feed.archiving.mode == "limitArticleAge") {
      "@maxArticleAge" = feed.archiving.maxArticleAge;
    }
    // lib.optionalAttrs (feed.archiving.mode == "limitArticleNumber") {
      "@maxArticleNumber" = feed.archiving.maxArticleNumber;
    }
    // lib.optionalAttrs (feed.updateInterval != null) {
      "@fetchInterval" = feed.updateInterval;
    }
    // setIfNonNull "@comment" feed.comment
    // setIfNonNull "@description" feed.description
    // setIfNonNull "@loadLinkedWebsite" feed.loadFullWebsite
    // setIfNonNull "@markImmediatelyAsRead" feed.markImmediatelyAsRead
    // setIfNonNull "@useNotification" feed.notify;

  xml = pkgs.formats.xml { };
in
{
  options.programs.akregator = {
    enable = lib.mkEnableOption "Akregator.";

    package = lib.mkPackageOption pkgs [ "kdePackages" "akregator" ] { nullable = true; };

    shortcutSchemes = lib.plasma.shortcutSchemesOption;

    feeds = lib.mkOption {
      description = "Feeds that Akregator fetches.";
      example."KDE Blogs" = {
        description = "Recent content on KDE Blogs";
        homepage = "https://blogs.kde.org/";
        type = "RSS";
        url = "https://blogs.kde.org/index.xml";
      };
      default = { };
      type = with lib.types; attrsOf (submodule feed);
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.mapAttrsToList (key: feed: {
      assertion = feed.homepage != null -> lib.hasPrefix feed.homepage feed.url;
      message =
        let
          optionPath = lib.showOption [
            "programs"
            "akregator"
            "feeds"
            key
          ];
        in
        ''
          For the Akregator feed '${optionPath}', the homepage is
          not a prefix of the feed URL:
          - homepage: '${feed.homepage}'
          - URL: '${feed.url}'
        '';
    }) cfg.feeds;

    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    programs.plasma.shortcutSchemes.akregator = cfg.shortcutSchemes;

    home.file'.".local/share/akregator/data/feeds.opml" = {
      type = "xml";
      mergeParams.stylesheet = ./merge-feeds.xslt;
      sources = [
        (xml.generate "akregator-feeds.xml" {
          opml.body.outline = map mkFeed (lib.attrValues cfg.feeds);
        })
      ];
    };
  };
}
