{ lib, ... }:

with lib;
let
  # Convert 2 consecutive characters from a string from hexadecimal to decimal
  hex2dec = str: start:
    let
      conversionTable = {
        "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
        "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
        "a" = 10; "b" = 11; "c" = 12;
        "d" = 13; "e" = 14; "f" = 15;
      };
      firstHexDigit  = toLower (elemAt (stringToCharacters str) start);
      secondHexDigit = toLower (elemAt (stringToCharacters str) (start + 1));
    in conversionTable.${firstHexDigit} * 16 + conversionTable.${secondHexDigit};

  makeColorCode = color:
    let genComponent = hex2dec color;
    in "${toString (genComponent 1)};${toString (genComponent 3)};${toString (genComponent 5)}";

  hex2RGB = color:
    let genComponent = hex2dec color;
    in {
      red = genComponent 1;
      green = genComponent 3;
      blue = genComponent 5;
    };

  fgEscapeCode = hexCode: "[38;2;${makeColorCode hexCode}m";
  bgEscapeCode = hexCode: "[48;2;${makeColorCode hexCode}m";
in
{
  inherit fgEscapeCode bgEscapeCode hex2RGB;
}
