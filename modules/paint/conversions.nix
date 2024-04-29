lib: let
  inherit (builtins) elemAt all isList isAttrs isString length attrNames filter;
  inherit (lib) mod;
  inherit (lib.strings) hasPrefix concatMapStrings stringToCharacters toLower;
in let
  hexChars = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };
  decToHex = let
    lookup = elemAt (attrNames hexChars);
  in
    v: (lookup (mod (v / 16) 16)) + (lookup (mod v 16));
  hexToDec = x: hexChars.${x};
  rgbToHex = v: let
    rgb = [v.r v.g v.b];
  in
    if all (x: 0 <= x && x <= 255) rgb
    then concatMapStrings decToHex rgb
    else abort "Color was invalid!";
  hexToRgb = hex: let
    arr = map hexToDec (stringToCharacters (toLower hex));
    ch = x: y: ((elemAt arr x) * 16) + (elemAt arr y);
  in {
    r = ch 0 1;
    g = ch 2 3;
    b = ch 4 5;
  };

  /*
  * Try to coerce the passed in value into an attribute set of {r, g, b}.
  */
  coerceToRgb = v:
    if isList v && (length v == 3)
    then {
      r = elemAt v 0;
      g = elemAt v 1;
      b = elemAt v 2;
    }
    else if isAttrs v && ((filter (v: !(hasPrefix "__" v)) (attrNames v)) == ["b" "g" "r"])
    then v
    else if isString v
    then hexToRgb v
    else throw "Value cannot be coerced into an RGB color.";
in {
  inherit hexChars;
  inherit hexToDec decToHex;
  inherit hexToRgb rgbToHex;
  inherit coerceToRgb;
}
