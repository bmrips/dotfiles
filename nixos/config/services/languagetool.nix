{ lib, pkgs, ... }:

let
  n-grams =
    let
      de = pkgs.fetchzip {
        url = "https://languagetool.org/download/ngram-data/ngrams-de-20150819.zip";
        hash = "sha256-b+dPqDhXZQpVOGwDJOO4bFTQ15hhOSG6WPCx8RApfNg=";
      };
      en = pkgs.fetchzip {
        url = "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
        hash = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
      };
      nl = pkgs.fetchzip {
        url = "https://languagetool.org/download/ngram-data/ngrams-nl-20181229.zip";
        hash = "sha256-bHOEdb2R7UYvXjqL7MT4yy3++hNMVwnG7TJvvd3Feg8=";
      };
    in
    pkgs.runCommand "languagetool_n-grams" { } ''
      mkdir $out
      ln -s ${de} $out/de
      ln -s ${en} $out/en
      ln -s ${nl} $out/nl
    '';
in
{
  services.languagetool.settings = {
    fasttextBinary = lib.getExe pkgs.fasttext;
    fasttextModel = pkgs.fetchurl {
      url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
      hash = "sha256-fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
    };
    languageModel = n-grams;
  };
}
