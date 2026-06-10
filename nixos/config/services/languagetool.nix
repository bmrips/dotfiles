{ lib, pkgs, ... }:

{
  config.services.languagetool = {
    n-grams = {
      de.enable = true;
      en.enable = true;
      nl.enable = true;
    };
    settings = {
      fasttextBinary = lib.getExe pkgs.fasttext;
      fasttextModel = pkgs.fetchurl {
        url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
        hash = "sha256-fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
      };
    };
  };
}
