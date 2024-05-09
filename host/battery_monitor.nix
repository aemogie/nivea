# Thanks to: 
# https://github.com/c2vi/nixos/blob/070ba4bd0912801a862f376cc39d52d845086886/mods/battery_monitor.nix
{
  config,
  pkgs,
  lib,
  ...
}:

# Regularly check the battery status and send a notification when it discharges
# below certain thresholds.
# Implemented by calling the `acpi` program regularly. This is the simpler and
# safer approach because the battery might not send discharging events.

let
  cfg = config.services.battery_monitor;
in
{
  options.services.battery_monitor.enable = (lib.mkEnableOption "a battery monitoring daemon") // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    # Regularly check battery status
    systemd.user.services.battery_monitor = {
      wants = [ "display-manager.service" ];
      wantedBy = [ "graphical-session.target" ];
      script = ''
        count_10=0
        prev_val=100
        check () { [[ $1 -ge $val ]] && [[ $1 -lt $prev_val ]]; }
        notify () {
          ${pkgs.libnotify}/bin/notify-send -a Battery "$@" \
            -h "int:value:$val" "Discharging" "$val%, $remaining"
        }
        while true; do
          IFS=: read _ bat0 < <(${pkgs.acpi}/bin/acpi -b)
          IFS=\ , read status val remaining <<<"$bat0"
          val=''${val%\%}
          if [[ $status = Discharging ]]; then
            echo "$val%, $remaining"

            if check 20; then notify
            elif check 15 || [[ $val -le 7 ]]; then notify -u critical
            elif [[ $val -le 4 ]]
            then 
              ${pkgs.notify}/bin/notify-send -a Hibernate soon...
              sleep 10
              ${pkgs.notify}/bin/notify-send -a Hibernate NOW
              sudo systemctl hibernate
            fi
          fi
          prev_val=$val
          # Sleep longer when battery is high to save CPU
          if [[ $val -gt 30 ]]; then sleep 10m; elif [[ $val -ge 20 ]]; then sleep 5m; else sleep 1m; fi
        done
      '';
    };
  };
}
