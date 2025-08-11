{ lib, ... }:

number:
let
  encipher =
    c:
    if c == 0 then
      "0"
    else if c == 1 then
      "1"
    else if c == 2 then
      "2"
    else if c == 3 then
      "3"
    else if c == 4 then
      "4"
    else if c == 5 then
      "5"
    else if c == 6 then
      "6"
    else if c == 7 then
      "7"
    else if c == 8 then
      "8"
    else if c == 9 then
      "9"
    else if c == 10 then
      "a"
    else if c == 11 then
      "b"
    else if c == 12 then
      "c"
    else if c == 13 then
      "d"
    else if c == 14 then
      "e"
    else if c == 15 then
      "f"
    else
      throw ("Error: not representable with a single hexadecimal cipher: " + toString c);
  hexCiphers =
    n:
    if n == 0 then
      [ ]
    else
      let
        n' = builtins.div n 16;
        c = encipher (n - 16 * n');
      in
      [ c ] ++ hexCiphers n';
in
lib.concatStrings (lib.reverseList (hexCiphers number))
