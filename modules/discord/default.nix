{ lib, ... }:
{
  imports = [
    # implementations
    ./webcord.nix
    ./openasar.nix
  ];

  options.programs.discord =
    let
      inherit (lib) mkEnableOption mkOption;
      inherit (lib.types) enum lines str;
    in
    {
      enable = mkEnableOption "Discord";
      client = mkOption {
        type = enum [
          "openasar"
          "webcord"
        ];
      };
      style = mkOption {
        type = lines;
        default = "";
        description = "A CSS file to be imported into the Discord Client, if it supports theming.";
      };
      launch_command = lib.mkOption {
        type = str;
        description = "Set by the implementation automatically. Used to set the command for WM keybinds.";
      };
    };
}
