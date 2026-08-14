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
    __printer = { expr }: "${expr}";
    inherit expr;
  };
  sym = name: mkElispInline "${name}";
  fnref = name: mkElispInline "#'${name}";
  quote = expr: mkElispInline "'${toElisp expr}";
  quasi = expr: mkElispInline "`${toElisp expr}";
  unquote = expr: mkElispInline ",${toElisp expr}";
  call = name: {
    __printer = { args, ... }: "(${concatMapStringsSep " " toElisp args})";
    __functor = self: arg: self // { args = self.args ++ [ arg ]; };
    args = [ (sym name) ];
  };

  mkKvPrinter =
    kvFmt: attrs: attrs // { __printer = concatMapAttrsStringSep " " kvFmt; };

  plist = mkKvPrinter (key: value: ":${key} ${toElisp value}");
  alist-list = mkKvPrinter (key: value: "(${key} ${toElisp value})");
  alist-cons = mkKvPrinter (key: value: "(${key} . ${toElisp value})");

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
        if v ? __printer then
          v.__printer (removeAttrs v [ "__printer" ])
        else
          abort "toElisp: bare attrsets not support, please use a printer"
      )
    else
      abort "toElisp: type ${typeOf v} is unsupported";
in
{
  inherit
    mkElispInline
    sym
    call
    fnref
    quote
    quasi
    unquote
    mkKvPrinter
    plist
    alist-list
    alist-cons
    toElisp
    ;
}
