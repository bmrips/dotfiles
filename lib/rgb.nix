lib:

{
  rgb = rec {

    parse =
      let
        byte = "([0-9a-fA-F]{2})";
      in
      map lib.hex2dec (lib.match "#${byte}${byte}${byte}");

    print =
      color:
      let
        result = "#" + lib.concatStrings (map lib.dec2hex color);
      in
      if parse result != null then result else throw "Error: not an RGB color specification!";

  };
}
