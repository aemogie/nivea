{
  layer = "top"; # Waybar at top layer
  position = "top"; # Waybar position (top|bottom|left|right)
  height = 36; # Waybar height (to be removed for auto height)
  # width= 1280; # Waybar width
  # spacing = 4; # Gaps between modules (4px)
  # Choose the order of the modules
  margin = "20 20 0 20";
  modules-left = [ "hyprland/workspaces" ];
  modules-right = [
    "wireplumber"
    "network"
    "battery"
    "clock"
    "tray"
  ];

  tray = {
    icon-size = 15;
    spacing = 0;
  };

  clock = {
    tooltip-format = "{calendar}";
    format-alt = "{:%d/%m/%Y}";
  };

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
    format-wifi = "󰖩";
    format-ethernet = "󰈀";
    tooltip-format = "󰈀 {bandwidthTotalBytes}";
    tooltip-format-wifi = "󰖩 {essid} ({bandwidthTotalBytes})";
    format-linked = "(No IP) 󰈀";
    format-disconnected = "⚠";
    format-alt = "{ifname}: {ipaddr}/{cidr}";
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
}
