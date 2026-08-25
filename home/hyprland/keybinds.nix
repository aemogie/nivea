{
  config,
  pkgs,
  lib,
  ...
}:
let
  mod = "SUPER";
  bind = key: action: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${action}")
    ];
  };
  bindMod = key: bind "${mod} + ${key}";
  exec = key: program: bind key "exec_cmd(\"${program}\")";
  execMod = key: program: bindMod key "exec_cmd(\"${program}\")";
  bindMouse = key: action: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${action}")
      { mouse = true; }
    ];
  };

  basic = [
    (bindMod "Q" "window.close()")
    (bindMod "O" "window.fullscreen({action = \"toggle\", mode = \"maximized\"})")
    (bindMod "SHIFT + O" "window.fullscreen({action = \"toggle\", mode = \"fullscreen\"})")
    (bindMod "U" "layout(\"togglesplit\")")

    # Canary
    (bindMod "N" "focus({ direction = \"left\" })")
    (bindMod "E" "focus({ direction = \"down\" })")
    (bindMod "I" "focus({ direction = \"up\" })")
    (bindMod "A" "focus({ direction = \"right\" })")
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
      (execMod "Space" "${foot}")
      (execMod "R" "${emacs}")
      (execMod "S" "${firefox}")
      (execMod "B" "${discord}")
      (execMod "SHIFT + T" "${music}")
      (execMod "C" "${grimblast}/bin/grimblast --freeze copy area")
      (execMod "SHIFT + C" "${grimblast}/bin/grimblast --freeze copy screen")
      (exec "PRINT" "${grimblast}/bin/grimblast --freeze copy screen")
    ];

  workspaces =
    let
      /*nixfmt:disable*/
      keys = [1 2 3 4 5 6 7 8 9 0];
      /*nixfmt:enable*/
      bindWksp = key: wksp: [
        (bindMod "${toString key}" "focus({ workspace = ${lib.toJSON wksp} })")
        (bindMod "SHIFT + ${toString key}" "window.move({ workspace = ${lib.toJSON wksp} })")
      ];
    in
    (lib.concatLists (lib.imap1 (lib.flip bindWksp) keys))
    ++ [
      (bindMod "semicolon" "workspace.toggle_special()")
      (bindMod "SHIFT + semicolon" "window.move({ workspace = \"special\" })")
    ]
    ++ (bindWksp "mouse_down" "e+1")
    ++ (bindWksp "mouse_up" "e-1");

  mouse = [
    (bindMouse "${mod} + mouse:272" "window.drag()")
    (bindMouse "${mod} + mouse:273" "window.resize()")
  ];

  gestures = [
    {
      fingers = 3;
      direction = "horizontal";
      action = "workspace";
    }
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
      (exec "XF86AudioRaiseVolume" (
        pkgs.writeShellScript "volup" ''
          ${
            if useWireplumber then
              "${wpctl} set-volume @DEFAULT_SINK@ ${volStep}+"
            else
              "${pactl} set-sink-volume @DEFAULT_SINK@ +${volStep}"
          }
          ${notif} "Volume +${volStep}"
        ''
      ))
      (exec "XF86AudioLowerVolume" (
        pkgs.writeShellScript "voldown" ''
          ${
            if useWireplumber then
              "${wpctl} set-volume @DEFAULT_SINK@ ${volStep}-"
            else
              "${pactl} set-sink-volume @DEFAULT_SINK@ -${volStep}"
          }
          ${notif} "Volume -${volStep}"
        ''
      ))
      (exec "XF86AudioMute" (
        pkgs.writeShellScript "volmut" ''
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
        ''
      ))
    ]
    ++ [
      (exec "XF86MonBrightnessUp" (
        pkgs.writeShellScript "briup" ''
          ${brictl} set +${briStep}
          ${notif} "Brightness +${briStep}"
        ''
      ))
      (exec "XF86MonBrightnessDown" (
        pkgs.writeShellScript "bridown" ''
          ${brictl} set ${briStep}-
          ${notif} "Brightness -${briStep}"
        ''
      ))
    ]
    ++ [
      # TODO: fix laptop keyboard
      (execMod "T" play-toggle)
      (exec "XF86AudioPlay" play-toggle)
      (exec "XF86AudioPause" play-toggle)
      (exec "XF86AudioPrev" (
        pkgs.writeShellScript "playprev" ''
          ${playctl} previous
          ${notif} "Playing previous"
        ''
      ))
      (exec "XF86AudioNext" (
        pkgs.writeShellScript "playnext" ''
          ${playctl} next
          ${notif} "Playing next"
        ''
      ))
    ];
in
{
  wayland.windowManager.hyprland.settings = {
    bind = basic ++ launch_app ++ workspaces ++ fnKeys ++ mouse;
    gesture = gestures;
  };
}
