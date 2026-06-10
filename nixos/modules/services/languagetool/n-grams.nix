{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.services.languagetool.n-grams =
    let
      mkNGramsLangModule =
        {
          language,
          url,
          hash,
        }:
        {
          enable = lib.mkEnableOption "${language} n-gram data";
          package = lib.mkOption {
            description = "The ${language} n-gram data package.";
            type = lib.types.package;
            default = pkgs.fetchzip { inherit url hash; };
            defaultText = lib.literalExpression ''
              pkgs.fetchzip {
                url = "${url}";
                hash = "${hash}";
              }
            '';
          };
        };
    in
    {
      de = mkNGramsLangModule {
        language = "German";
        url = "https://languagetool.org/download/ngram-data/ngrams-de-20150819.zip";
        hash = "sha256-b+dPqDhXZQpVOGwDJOO4bFTQ15hhOSG6WPCx8RApfNg=";
      };
      en = mkNGramsLangModule {
        language = "English";
        url = "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
        hash = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
      };
      es = mkNGramsLangModule {
        language = "Spanish";
        url = "https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip";
        hash = "sha256-mA2dFEscDNr4tJQzQnpssNAmiSpd9vaDX8e+21OJUgQ=";
      };
      fr = mkNGramsLangModule {
        language = "French";
        url = "https://languagetool.org/download/ngram-data/ngrams-fr-20150913.zip";
        hash = "sha256-z+JJe8MeI9YXE2wUA2acK9SuQrMZ330QZCF9e234FCk=";
      };
      nl = mkNGramsLangModule {
        language = "Dutch";
        url = "https://languagetool.org/download/ngram-data/ngrams-nl-20181229.zip";
        hash = "sha256-bHOEdb2R7UYvXjqL7MT4yy3++hNMVwnG7TJvvd3Feg8=";
      };
    };

  config.services.languagetool.settings.languageModel =
    let
      enabledNGrams = lib.filterAttrs (_: v: v.enable) config.services.languagetool.n-grams;
      buildCommand = lib.concatLines (
        [ "mkdir $out" ] ++ lib.mapAttrsToList (n: v: "ln -s ${v.package} $out/${n}") enabledNGrams
      );
    in
    lib.mkIf (enabledNGrams != { }) (pkgs.runCommand "languagetool_n-grams" { } buildCommand);
}
