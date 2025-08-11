{ lib, self, ... }:

{

  parse =
    let
      byte = "([0-9a-fA-F]{2})";
    in
    hex: map lib.hex2dec (lib.match "#${byte}${byte}${byte}" hex);

  print =
    color:
    let
      result = "#" + lib.concatStrings (map lib.dec2hex color);
    in
    if self.parse result != null then result else throw "Error: not an RGB color specification!";

}
