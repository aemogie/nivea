lib:
let
  inherit (lib)
    const
    filter
    isStringLike
    concatMap
    genAttrs
    toList
    isFunction
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
    concatStringsSep
    concatMapAttrsStringSep
    types
    ;

  mkPrinter =
    printer: attrs:
    attrs
    // {
      _type = "elisp";
      __toString =
        attrs:
        printer (
          removeAttrs attrs [
            "_type"
            "__toString"
          ]
        );
    };
  mkElispInline = expr: mkPrinter ({ expr }: "${expr}") { inherit expr; };

  _nothing = mkPrinter (const "") { };
  splice =
    xs:
    mkPrinter (
      { xs }: concatStringsSep " " (filter (s: s != "") (map toElisp xs))
    ) { inherit xs; };
  bareList =
    xs: mkPrinter ({ xs }: "(${toElisp (splice xs)})") { xs = toList xs; };
  bareCons =
    car: cdr:
    mkPrinter ({ car, cdr }: "(${toElisp car} . ${toElisp cdr})") {
      inherit car cdr;
    };
  sym = name: mkPrinter ({ name }: "'${name}") { inherit name; };
  bareSym = name: mkPrinter ({ name }: "${name}") { inherit name; };
  var = bareSym;
  fnref = name: mkPrinter ({ name }: "#'${name}") { inherit name; };
  quote = expr: mkPrinter ({ expr }: "'${toElisp expr}") { inherit expr; };
  quasi = expr: mkPrinter ({ expr }: "`${toElisp expr}") { inherit expr; };
  unquote = expr: mkPrinter ({ expr }: ",${toElisp expr}") { inherit expr; };
  call =
    name:
    mkPrinter ({ args, ... }: toElisp (bareList args)) {
      __functor = self: arg: self // { args = self.args ++ [ arg ]; };
      args = [ (bareSym name) ];
    };
  cons = car: cdr: call "cons" car cdr;
  defun =
    {
      name,
      args ? [ ],
      interactive ? false,
      docstring ? false,
      body,
    }:
    let
      normalizeArg =
        arg:
        if isString arg then
          { name = arg; }
        else if arg ? name && (arg.optional or false) && !(arg.rest or false) then
          arg
        else if arg ? name && (arg.rest or false) && !(arg.optional or false) then
          arg
        else
          abort "elisp.defun: arg is invalid";
      params = genAttrs (map (arg: arg.name or arg) args) var;
      printer =
        {
          name,
          args ? [ ],
          interactive ? false,
          docstring ? false,
          body,
        }:
        let
          argListMapper = arg: [
            (if arg.optional or false then (bareSym "&optional") else _nothing)
            (if arg.rest or false then (bareSym "&rest") else _nothing)
            (bareSym arg.name)
          ];
          argList = bareList (concatMap argListMapper args);
          lookup =
            { name, ... }:
            interactive.${name} or (abort "elisp.defun: missing ${name} in interactive");
          interactive' = call "interactive" (map lookup args);
        in
        toElisp (
          call "defun" (bareSym name) argList (splice [
            (if docstring == false then _nothing else docstring)
            (if interactive == false then _nothing else interactive')
            (splice body)
          ])
        );
    in
    mkPrinter printer {
      inherit name docstring;
      interactive =
        if isBool interactive && !interactive then
          false
        else if isBool interactive && interactive then
          { }
        else if isAttrs interactive then
          interactive
        else
          abort "elisp.defun: invalid interactive section";
      args = map normalizeArg args;
      body = toList (
        if isFunction body && (body._type or "") != "elisp" then body params else body
      );
    };
  lambda =
    {
      args ? [ ],
      interactive ? false,
      docstring ? false,
      body,
    }:
    let
      normalizeArg =
        arg:
        if isString arg then
          { name = arg; }
        else if arg ? name && (arg.optional or false) && !(arg.rest or false) then
          arg
        else if arg ? name && (arg.rest or false) && !(arg.optional or false) then
          arg
        else
          abort "elisp.lambda: arg is invalid";
      params = genAttrs (map (arg: arg.name or arg) args) var;
      printer =
        {
          args ? [ ],
          interactive ? false,
          docstring ? false,
          body,
        }:
        let
          argListMapper = arg: [
            (if arg.optional or false then (bareSym "&optional") else _nothing)
            (if arg.rest or false then (bareSym "&rest") else _nothing)
            (bareSym arg.name)
          ];
          argList = bareList (concatMap argListMapper args);
          lookup =
            { name, ... }:
            interactive.${name} or (abort "elisp.lambda: missing ${name} in interactive");
          interactive' = call "interactive" (map lookup args);
        in
        toElisp (
          call "lambda" argList (splice [
            (if docstring == false then _nothing else docstring)
            (if interactive == false then _nothing else interactive')
            (splice body)
          ])
        );
    in
    mkPrinter printer {
      inherit docstring;
      interactive =
        if isBool interactive && !interactive then
          false
        else if isBool interactive && interactive then
          { }
        else if isAttrs interactive then
          interactive
        else
          abort "elisp.lambda: invalid interactive section";
      args = map normalizeArg args;
      body = toList (
        if isFunction body && (body._type or "") != "elisp" then body params else body
      );
    };
  eval = body: call "eval" (quote (call "progn" (splice (toList body))));
  if' =
    cond: then': else':
    mkPrinter
      (
        {
          cond,
          then',
          else',
        }:
        toElisp (call "if" cond then' else')
      )
      {
        inherit cond then' else';
      };
  when =
    cond: body:
    mkPrinter ({ cond, body }: toElisp (call "when" cond body)) {
      inherit cond body;
    };
  and =
    all: mkPrinter ({ all }: toElisp (call "and" (splice all))) { inherit all; };

  mkKvPrinter = kvFmt: mkPrinter (concatMapAttrsStringSep " " kvFmt);

  /*nixfmt:disable*/
  plist = mkKvPrinter (key: value: ":${key} ${toElisp value}");
  alist-list = mkKvPrinter (key: value: toElisp (bareList [(bareSym key) value]));
  alist-cons = mkKvPrinter (key: value: toElisp (bareCons (bareSym key) value));
  sane-alist-cons = attrs: [ (mkKvPrinter (k: v: toElisp (cons (sym k) v)) attrs) ];
  /*nixfmt:enable*/

  toElisp =
    v:
    if isBool v && !v then
      "nil"
    else if isBool v && v then
      "t"
    else if isInt v || isFloat v || isString v then
      toJSON v
    else if isPath v || isDerivation v then
      toJSON "${v}"
    else if isList v then
      toElisp (call "list" (splice v))
    else if (v._type or "") == "elisp" && isStringLike v then
      "${v}"
    else
      abort "toElisp: type ${typeOf v} is unsupported";

  elispExprType =
    let
    in
    (types.oneOf [
      types.bool
      types.int
      types.float
      types.str
      types.path
      (types.addCheck types.attrs (
        {
          _type ? "",
          ...
        }@args:
        _type == "elisp" && isStringLike args
      ))
      (types.listOf elispExprType)
    ])
    // {
      description = "elisp value";
    };
in
{
  inherit
    mkPrinter
    mkElispInline
    splice
    bareList
    cons
    bareCons
    sym
    bareSym
    var
    call
    defun
    lambda
    eval
    if'
    when
    and
    fnref
    quote
    quasi
    unquote
    mkKvPrinter
    plist
    alist-list
    alist-cons
    sane-alist-cons
    toElisp
    elispExprType
    ;
}
