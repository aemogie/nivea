lib:
let
  inherit (lib)
    isBool
    isInt
    isFloat
    isString
    toJSON
    isPath
    isDerivation
    isList
    isAttrs
    typeOf
    concatMapStringsSep
    concatMapAttrsStringSep
    ;

  mkElispInline = expr: {
    _printer = { expr }: "${expr}";
    inherit expr;
  };

  mkKvPrinter =
    kvFmt: attrs: attrs // { _printer = concatMapAttrsStringSep " " kvFmt; };

  kwArgs = mkKvPrinter (key: value: ":${key} ${toElisp value}");
  plist = mkKvPrinter (key: value: "(${key} ${toElisp value})");
  alist = mkKvPrinter (key: value: "(${key} . ${toElisp value})");

  toElisp =
    v:
    if v == null || (isBool v && !v) then
      "nil"
    else if isBool v && v then
      "t"
    else if isInt v || isFloat v || isString v then
      toJSON v
    else if isPath v || isDerivation v then
      toJSON "${v}"
    else if isList v then
      "(list " + (concatMapStringsSep " " toElisp v) + ")"
    else if isAttrs v then
      (
        if v ? _printer then
          v._printer (removeAttrs v [ "_printer" ])
        else
          abort "toElisp: bare attrsets not support, please use a printer"
      )
    else
      abort "toElisp: type ${typeOf v} is unsupported";
in
{
  inherit
    mkElispInline
    mkKvPrinter
    kwArgs
    plist
    alist
    toElisp
    ;
}
