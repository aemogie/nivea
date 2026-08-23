{
  config,
  pkgs,
  lib,
  ...
}:
let
  mod = "SUPER";

  basic = [
    "${mod}, Q, killactive"
    "${mod}, O, fullscreen, 1" # maximise, not fullscreen
    "${mod} SHIFT, O, fullscreen, 0" # fullscreen
    "${mod}, U, layoutmsg,  togglesplit"

    # Canary
    "${mod}, N, movefocus,  l"
    "${mod}, E, movefocus,  d"
    "${mod}, I, movefocus,  u"
    "${mod}, A, movefocus,  r"
  ];

  launch_app =
    let
      grimblast = pkgs.grimblast.override {
        hyprland = config.wayland.windowManager.hyprland.finalPackage;
      };
      discord =
        let
          cfg = config.programs.vesktop;
          pkg = (cfg.package.override { withSystemVencord = cfg.vencord.useSystem; });
        in
        lib.getExe pkg;
      firefox = lib.getExe config.programs.firefox.finalPackage;
      music = lib.getExe pkgs.pear-desktop;
      foot =
        if config.programs.foot.server.enable then
          "${config.programs.foot.package}/bin/footclient"
        else
          "${config.programs.foot.package}/bin/foot";
      emacs = config.home.sessionVariables.EDITOR;
    in
    [
      # figure out pyprland scratchpads and use that
      "${mod}, Space,    exec, ${foot}" # for emergencies
      "${mod}, R,        exec, ${emacs}"
      "${mod}, S,        exec, ${firefox}"
      "${mod}, B,        exec, ${discord}"
      "${mod} SHIFT, T,  exec, ${music}"
      "${mod}, C,        exec, ${grimblast}/bin/grimblast --freeze copy area"
      "${mod} SHIFT, C,  exec, ${grimblast}/bin/grimblast --freeze copy screen"
      ", PRINT,          exec, ${grimblast}/bin/grimblast --freeze copy screen"
    ];

  workspaces =
    (builtins.concatMap (x: [
      "${mod},       ${
        if x == 10 then "0" else toString x
      }, workspace,       ${toString x}"
      "${mod} SHIFT, ${
        if x == 10 then "0" else toString x
      }, movetoworkspace, ${toString x}"
    ]) (lib.range 1 10))
    ++ [
      "${mod},           grave, togglespecialworkspace"
      "${mod} SHIFT,     grave, movetoworkspace, special"
      "${mod},       semicolon, togglespecialworkspace"
      "${mod} SHIFT, semicolon, movetoworkspace, special"
    ]
    ++ [
      "${mod}, mouse_down, workspace, e+1"
      "${mod}, mouse_up,   workspace, e-1"
    ];

  mouse = [
    "${mod}, mouse:272, movewindow"
    "${mod}, mouse:273, resizewindow"
  ];

  gestures = [
    "3, horizontal, workspace"
  ];

  fnKeys =
    let
      notif = lib.getExe pkgs.libnotify;
      volStep = "5%";
      briStep = "5%";
      useWireplumber = true;
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      brictl = lib.getExe pkgs.brightnessctl;
      playctl = lib.getExe pkgs.playerctl;
      play-toggle = pkgs.writeShellScript "playtoggle" ''
        if ${playctl} -a status | grep -q "Playing"; then
          ${playctl} -a pause
          ${notif} "Paused All"
        else
          ${playctl} play # play first
          ${notif} "Resuming: $(${playctl} -l | head -n 1)"
        fi
      '';
    in
    # TODO: better notifs
    [
      ", XF86AudioRaiseVolume, exec, ${pkgs.writeShellScript "volup" ''
        ${
          if useWireplumber then
            "${wpctl} set-volume @DEFAULT_SINK@ ${volStep}+"
          else
            "${pactl} set-sink-volume @DEFAULT_SINK@ +${volStep}"
        }
        ${notif} "Volume +${volStep}"
      ''}"
      ", XF86AudioLowerVolume, exec, ${pkgs.writeShellScript "voldown" ''
        ${
          if useWireplumber then
            "${wpctl} set-volume @DEFAULT_SINK@ ${volStep}-"
          else
            "${pactl} set-sink-volume @DEFAULT_SINK@ -${volStep}"
        }
        ${notif} "Volume -${volStep}"
      ''}"
      ", XF86AudioMute, exec, ${pkgs.writeShellScript "volmut" ''
        ${
          if useWireplumber then
            "${wpctl} set-mute @DEFAULT_SINK@ toggle"
          else
            "${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        }
        ${notif} "Speaker $([[ $(${
          if useWireplumber then
            "${wpctl} get-volume @DEFAULT_SINK@ | grep ' \[MUTED\]$'"
          else
            "${pactl} get-sink-mute @DEFAULT_SINK@ | grep 'Mute: yes'"
        }) ]] && echo Muted || echo Unmuted)"
      ''}"
    ]
    ++ [
      ", XF86MonBrightnessUp, exec, ${pkgs.writeShellScript "briup" ''
        ${brictl} set +${briStep}
        ${notif} "Brightness +${briStep}"
      ''}"
      ", XF86MonBrightnessDown, exec, ${pkgs.writeShellScript "bridown" ''
        ${brictl} set ${briStep}-
        ${notif} "Brightness -${briStep}"
      ''}"
    ]
    ++ [
      # TODO: fix laptop keyboard
      "${mod}, T, exec, ${play-toggle}"
      ", XF86AudioPlay, exec, ${play-toggle}"
      ", XF86AudioPause, exec, ${play-toggle}"
      ", XF86AudioPrev, exec, ${pkgs.writeShellScript "playprev" ''
        ${playctl} previous
        ${notif} "Playing previous"
      ''}"
      ", XF86AudioNext, exec, ${pkgs.writeShellScript "playnext" ''
        ${playctl} next
        ${notif} "Playing next"
      ''}"
    ];
in
{
  wayland.windowManager.hyprland.settings = {
    bind = basic ++ launch_app ++ workspaces ++ fnKeys;
    bindm = mouse;
    gesture = gestures;
  };
}
