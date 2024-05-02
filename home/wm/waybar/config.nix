{ pkgs, lib, ... }:
with lib;
let
  title-rewrites =
    let
      site_list = [
        [
          "github.com"
          "󰊤"
          ""
        ]
        [
          "stackoverflow.com"
          ""
          " - Stack Overflow"
        ]
        [
          "youtube.com"
          "󰗃 "
          ""
        ]
        [
          "youtube.com"
          "󰗃 "
          " - YouTube"
        ]
        [
          "google.com"
          "󰊭"
          " - Google Search"
        ]
        [
          "mail.google.com"
          "󰊫"
          " - .*"
        ]
        [
          "whatsapp.com"
          "󰖣"
          ""
        ]
        [
          "nixos.org"
          ""
          ""
        ]
        [
          "discourse.nixos.org"
          ""
          " - NixOS Discourse"
        ]
        [
          "monkeytype.com"
          "󰌌"
          ""
        ]
      ];
      site_list_converted = map (
        parts:
        let
          domain = elemAt parts 0;
          icon = elemAt parts 1;
          extra = elemAt parts 2;
        in
        ''
          "^(.*)${extra} \\[(?:.*)\\b${
            replaceStrings [ "." ] [ "\\\\." ] domain
          }\\] — Mozilla Firefox$" : "${icon} $1"
        ''
      ) site_list;
    in
    #json
    ''
      {
        ${concatStringsSep "," site_list_converted},
        "^(.*) \\[.*\\] — Mozilla Firefox$": "󰈹 $1",
        "^(?:New Tab — )?Mozilla Firefox$": "󰈹",

        "^hx$": "󰅩",
        "^(.*) - WezTerm$": "󰆍 $1",
        "^foot$": "󰆍 ",

        "^(?:\\[\\d+\\] |\\*)?WebCord - (.*) \\((.*)\\)$": "󰙯 $1 󰒋 $2",
        "^(?:\\[\\d+\\] |\\*)?WebCord - (.*)$": "󰙯 $1",

        "^Spotify$": "󰓇",

        "^(?:(.*) - )?Aseprite v[\\d\\.]*$": "󰃣 $1"
      }
    '';
  config = {
    layer = "top"; # Waybar at top layer
    position = "top"; # Waybar position (top|bottom|left|right)
    height = 36; # Waybar height (to be removed for auto height)
    # width= 1280; # Waybar width
    # spacing = 4; # Gaps between modules (4px)
    # Choose the order of the modules
    margin = "20 20 0 20";
    modules-left = [
      "hyprland/workspaces"
      "hyprland/window"
    ];
    modules-right = [
      "custom/media"
      "pulseaudio"
      "network"
      "battery"
      "clock"
      "tray"
    ];
    # Modules configuration
    "hyprland/workspaces" = {
      # persistent_workspaces."*" = 4;
    };

    # replaced externally, as order is important
    "hyprland/window".rewrite = "@title-rewrites@";

    keyboard-state = {
      numlock = true;
      capslock = true;
      format = "{name} {icon}";
      format-icons = {
        locked = "";
        unlocked = "";
      };
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      icon-size = 15;
      spacing = 0;
    };
    clock = {
      # timezone= "America/New_York";
      tooltip-format = "{calendar}";
      format-alt = "{:%d/%m/%Y}";
    };
    # backlight = {
    #   format = "{icon}";
    #   format-icons = ["" "" "" "" "" "" "" "" ""];
    #   tooltip-format = "{percent}%";
    # };
    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      interval = 5;
      format = "{icon}";
      format-charging = "󰂄";
      format-plugged = "󰚥";
      fomrat-critical = "󰂃";
      format-alt = "{time} {icon}";
      tooltip-format = "{time} {capacity}%";
      # format-good= ""; # An empty format will hide the module
      # format-full= "";
      format-icons = [
        "󰂎"
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };
    network = {
      # interface= "wlp2*"; # (Optional) To force the use of this interface
      format-wifi = "";
      format-ethernet = "󰈀";
      tooltip-format = "󰈀 {bandwidthTotalBytes}";
      tooltip-format-wifi = " {essid} ({bandwidthTotalBytes})";
      format-linked = "(No IP) 󰈀";
      format-disconnected = "⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    pulseaudio = {
      # scroll-step= 1; # %, can be a float
      format = "{icon}";
      format-muted = "󰝟";
      tooltip-format = "{volume}% {format_source}";
      # format-source= "{volume}% ";
      # format-source-muted = "";
      format-icons = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
    };
    wireplumber = {
      format = "{icon}";
      format-muted = "󰝟";
      tooltip-format = "{volume}% {node_name}";
      format-icons = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
    };
    "custom/media" = {
      format = "{icon} {}";
      return-type = "json";
      max-length = 40;
      format-icons = {
        spotify = "";
      };
      escape = true;
      exec = "${pkgs.waybar.override { withMediaPlayer = true; }}/bin/waybar-mediaplayer.py 2> /dev/null";
      on-click = "${pkgs.hyprland}/bin/hyprctl dispatch focuswindow title:Spotify";
    };
  };
in
{
  xdg.configFile."waybar/config".text = replaceStrings [ ''"@title-rewrites@"'' ] [ title-rewrites ] (
    builtins.toJSON config
  );
}
