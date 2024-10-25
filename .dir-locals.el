((nix-mode . ((eglot-server-programs . ((nix-mode . ("nixd"))))
              (eglot-workspace-configuration
               . (:nixd
                  (:nixpkgs (:expr "
let
  pwd = builtins.getEnv \"PWD\";
  flake = builtins.getFlake \"git+file://${pwd}\";
  nixpkgs = flake.inputs.nixpkgs;
in
nixpkgs.legacyPackages.${builtins.currentSystem}
")
                   :options (:nixos (:expr "
let
  pwd = builtins.getEnv \"PWD\";
  flake = builtins.getFlake \"git+file://${pwd}\";
  hostnameEnv = builtins.getEnv \"HOSTNAME\";
  hostnameFile = builtins.readFile \"/etc/hostname\";
  hostname =
    if (builtins.stringLength hostnameEnv) == 0 then
      builtins.substring 0 ((builtins.stringLength hostnameFile) - 1) hostnameFile
    else
      hostnameEnv;
  nixos = flake.nixosConfigurations.${hostname};
in
nixos.options
")
                             :home-manager (:expr "

let
  pwd = builtins.getEnv \"PWD\";
  flake = builtins.getFlake \"git+file://${pwd}\";
  hostnameEnv = builtins.getEnv \"HOSTNAME\";
  hostnameFile = builtins.readFile \"/etc/hostname\";
  hostname =
    if (builtins.stringLength hostnameEnv) == 0 then
      builtins.substring 0 ((builtins.stringLength hostnameFile) - 1) hostnameFile
    else
      hostnameEnv;
  nixos = flake.nixosConfigurations.${hostname};
in
nixos.options.home-manager.users.type.nestedTypes.elemType.getSubOptions []
"))
                   :formatting (:command ["nixfmt"]))))))
 (emacs-lisp-mode . ((lexical-binding . t))))
