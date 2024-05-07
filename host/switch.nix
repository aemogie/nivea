{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.sys-switch;
  switch = pkgs.writeShellApplication {
    name = "switch";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.nixos-rebuild
      # nix needs this in path it seems? why isn't it using the one from nix store?
      pkgs.git
    ];
    text =
      if cfg.autoDark.enable then # sh
        ''
          date="$(date +%H)"
          if
            [ "$date" -ge ${toString cfg.autoDark.time.morning} ] && \
            [ "$date" -lt "${toString cfg.autoDark.time.evening}" ]
          then
            nixos-rebuild switch "$@"
          else
            nixos-rebuild test --specialisation dark "$@" && \
            (nixos-rebuild boot "$@" >/dev/null 2>&1 &)
          fi
        ''
      # sh
      else
        ''nixos-rebuild switch'';
  };
  sudoSwitch = pkgs.writeShellApplication {
    name = "switch";
    runtimeInputs = [ switch ];
    text = ''
      if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo not found in environment"
        exit 1
      fi

      sudo switch "$@"
    '';
  };
  mkOptOut =
    description:
    mkOption {
      type = types.bool;
      default = true;
      inherit description;
    };
  mkOptIn =
    description:
    mkOption {
      type = types.bool;
      default = false;
      inherit description;
    };
in
{
  options.services.sys-switch = {
    enable = mkOptOut "enable a custom switch script";
    noSudo = mkOptOut "allow all users in @wheel group to switch without using `sudo`";
    autoDark = {
      enable = mkOptOut "make switch script sensitive to current time";
      time = {
        morning = mkOption {
          type = types.int;
          default = 7;
          description = "which hour to switch to light mode";
        };
        evening = mkOption {
          type = types.int;
          default = 17;
          description = "which hour to switch to dark mode";
        };
      };
      # TODO: fix doesnt work
      systemd-timer = mkOptIn "switch to dark mode in the background";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = if cfg.noSudo then [ sudoSwitch ] else [ switch ];
    security.sudo.extraRules = mkIf cfg.noSudo [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = lib.getExe switch;
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    systemd = mkIf cfg.autoDark.systemd-timer {
      timers."sys-switch" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "${toString cfg.autoDark.time.morning},${toString cfg.autoDark.time.evening}:00";
          Unit = "sys-switch.service";
        };
      };

      services."sys-switch" = {
        script = lib.getExe switch;
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
    specialisation = mkIf cfg.autoDark.enable {
      dark.configuration =
        { config, ... }:
        {
          paint.active = config.paint.dark;
        };
    };
  };
}
