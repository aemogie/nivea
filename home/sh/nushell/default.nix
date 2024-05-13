{ config, ... }:
{
  imports = [
    ./config.nix
    ../../../modules/nushell.nix
  ];

  # the benefit of doing it as a nixos module instead of standalone.
  # might move to standalone tho, for portability
  home.loginShell = {
    package = config.programs.nushell.package;
    args = [
      "--login"
      "--stdin"
      "--commands"
    ];
  };
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;
    config = {
      show_banner = false;
      rm.always_trash = true;
      table.index_mode = "auto";
      history.file_format = "sqlite";
      shell_integration = false;
      use_kitty_protocol = false;
    };
    # TODO: make into portable scripts
    shellAliases = builtins.removeAttrs config.home.shellAliases [ "e" ];
    envFile.text =
      #nu
      ''
        $env.ENV_CONVERSIONS = {
            "PATH": {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
            }
            "Path": {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
            }
        }
      '';
    loadSessionVariables = true;
  };
}
