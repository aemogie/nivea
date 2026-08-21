{
  config,
  name ? null,
  lib',
  ...
}:
let
  inherit (lib')
    isBool
    isString
    isList
    isAttrs
    isFunction
    toList
    types
    mkOption
    mkEnableOption
    literalExpression
    filterAttrs
    listToAttrs
    mapAttrsToList
    mapAttrs'
    nameValuePair
    typeOf
    elisp
    ;
  typeWithTransform =
    transform: elemType:
    elemType
    // {
      merge = loc: defs: transform (elemType.merge loc defs);
      nestedTypes.elemType = elemType;
    };
in
{
  options = {
    enable = (mkEnableOption "use-package configuration for ${name}") // {
      # refer: (use-package)Top > Loading Packages > The emacs package
      default = name == "emacs";
    };
    package = mkOption {
      type = typeWithTransform (x: if isFunction x then x else _: x) (
        types.nullOr (types.either types.package (types.functionTo types.package))
      );
      default = if name == "emacs" then null else epkgs: epkgs.${name};
      defaultText = literalExpression "epkgs: epkgs.${name}";
      description = "The emacs package to install, or null for a builtin package";
    };

    custom = mkOption {
      type = types.nullOr (typeWithTransform elisp.alist-list types.attrs);
      default = null;
    };

    hook = mkOption {
      type =
        let
          f =
            key: value:
            if isBool value && value then
              f key "${name}-mode"
            else if isList value then
              elisp.splice (map (f key) value)
            else if isString value then
              elisp.bareCons (elisp.bareSym key) (elisp.bareSym value)
            else
              abort "use-package.${name}.hook: values must be an elisp function name or 'true'";
        in
        types.nullOr (
          typeWithTransform (
            attrs: elisp.bareList (elisp.mkKvPrinter f attrs)
          ) types.attrs
        );
      default = null;
    };

    bind = mkOption {
      type =
        let
          normalizeAction =
            action:
            if isString action then
              elisp.fnref action
            else
              elisp.lambda {
                interactive = true;
                body = action;
              };
          keymaps =
            keymap: keybinds:
            elisp.splice [
              (elisp.mkElispInline ":map")
              (elisp.bareSym keymap)
              (elisp.mkKvPrinter (
                key: action: elisp.toElisp (elisp.bareCons key (normalizeAction action))
              ) keybinds)
            ];
        in
        types.nullOr (
          typeWithTransform (attrs: elisp.bareList (elisp.mkKvPrinter keymaps attrs)) (
            types.attrsOf (types.attrsOf (types.either types.str elisp.elispExprType))
          )
        );
      default = null;
    };

    mode = mkOption {
      type =
        let
          normalize =
            value:
            if isString value then
              { "${value}" = name; }
            else if isList value then
              listToAttrs (map (x: nameValuePair x name) value)
            else if isAttrs value then
              mapAttrs' (
                key: value:
                if isBool value && value then
                  nameValuePair key name
                else if isString value then
                  nameValuePair key value
                else
                  abort "use-package.${name}.mode.${key}: value must be 'true' or mode name"
              ) value
            else
              abort "use-package.${name}.mode: unsupported type ${typeOf value}";
          # "can be a cons cell, a list of cons cells, or a string or regexp"
          # we are normalising all to "list of cons cells"
          transform =
            value:
            let
              pair = regexp: mode: elisp.bareCons regexp (elisp.bareSym mode);
            in
            elisp.mkPrinter (
              self: elisp.toElisp (elisp.bareList (mapAttrsToList pair self))
            ) (normalize value);
        in
        types.nullOr (
          typeWithTransform transform (
            types.oneOf [
              types.str
              (types.listOf types.str)
              (types.attrsOf (types.either types.bool types.str))
            ]
          )
        );
      default = null;
    };

    config' = mkOption {
      type = types.nullOr (
        typeWithTransform elisp.splice (
          types.coercedTo elisp.elispExprType toList (types.listOf elisp.elispExprType)
        )
      );
      default = null;
    };

    init = mkOption {
      type = types.nullOr (
        typeWithTransform elisp.splice (
          types.coercedTo elisp.elispExprType toList (types.listOf elisp.elispExprType)
        )
      );
      default = null;
    };

    preface = mkOption {
      type = types.nullOr (
        typeWithTransform elisp.splice (
          types.coercedTo elisp.elispExprType toList (types.listOf elisp.elispExprType)
        )
      );
      default = null;
    };

    requires = mkOption {
      type =
        let
          transform = xs: elisp.bareList (map elisp.bareSym xs);
        in
        types.nullOr (typeWithTransform transform (types.listOf types.str));
      default = null;
    };
    after = mkOption {
      type =
        let
          transform =
            xs:
            elisp.mkPrinter (
              { xs }: elisp.toElisp (elisp.bareList (map elisp.bareSym xs))
            ) { inherit xs; };
        in
        types.nullOr (typeWithTransform transform (types.listOf types.str));
      default = null;
    };
    demand = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };
    defer = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    fullConfig = mkOption {
      type =
        let
          transform =
            sections: elisp.call "use-package" (elisp.bareSym name) (elisp.plist sections);
        in
        typeWithTransform transform types.attrs;
      default = filterAttrs (_: v: v != null) {
        inherit (config)
          custom
          hook
          bind
          demand
          defer
          mode
          requires
          after
          init
          preface
          ;
        config = config.config';
      };
    };
  };
}
