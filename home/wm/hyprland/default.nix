{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  imports = [
    # inferior to upstream hm's nix native config `settings`
    # inputs.hyprland.homeManagerModules.default
    ./keybinds.nix
  ];

  home.packages = [ pkgs.hyprpicker ];

  systemd.user.sessionVariables.NIXOS_OZONE_WL = "1";
  wayland.windowManager.hyprland =
    let
      opacity = "0.9";
    in
    {
      enable = true;
      settings = {
        # monitor = ",${toString mon.w}x${toString mon.h},0x0,1";
        monitor = ",preferred,auto,1";

        exec-once = [
          "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
        ];

        input = {
          numlock_by_default = true;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
        };
        gestures.workspace_swipe = true;

        general =
          let
            inherit (osConfig.paint.active.palette) primary alternate crust;
          in
          {
            gaps_out = 20;
            border_size = 3;
            gaps_in = 10;
            # dont be fooled, these are all hex not dec
            "col.active_border" = "rgb(${primary})";
            "col.inactive_border" = "rgba(${crust}FF)";
          };

        misc = {
          enable_swallow = true; # swallow_regex set in terminal module
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_autoreload = true;
          new_window_takes_over_fullscreen = 2; # unfullscreen the current
          initial_workspace_tracking = 1;
          animate_mouse_windowdragging = true;
          animate_manual_resizes = true;
          focus_on_activate = true;
        };

        dwindle = {
          preserve_split = true;
          smart_split = true;
        };

        decoration = {
          rounding = 5;

          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            ignore_opacity = true;
            # popups = true;
            # popups_ignorealpha = 0;
            xray = true;
            special = true;
          };

          # inherit active_opacity inactive_opacity;
          # fullscreen_opacity = active_opacity;
        };
      };
    };
}
