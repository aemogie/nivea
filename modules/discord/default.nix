{ lib, ... }:
{
  imports = [
    # implementations
    ./webcord.nix
    ./openasar.nix
  ];

  options.programs.discord =
    let
      inherit (lib) types mkEnableOption mkOption;
    in
    {
      enable = mkEnableOption "Discord";
      client = mkOption {
        type = types.enum [
          "openasar"
          "webcord"
        ];
      };
      style = mkOption {
        type = types.either types.pathInStore types.lines;
        default = "";
        description = "A CSS file to be imported into the Discord Client, if it supports theming.";
      };
      launch_command = lib.mkOption {
        type = types.str;
        description = "Set by the implementation automatically. Used to set the command for WM keybinds.";
      };
    };
}
