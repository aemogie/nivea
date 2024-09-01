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
    "${mod}, V, togglefloating"
    "${mod}, O, fullscreen, 1" # maximise, not fullscreen
    "${mod}, T, layoutmsg,  togglesplit"

    "${mod}, H, movefocus,  l"
    "${mod}, J, movefocus,  d"
    "${mod}, K, movefocus,  u"
    "${mod}, L, movefocus,  r"
  ];

  launch_app =
    let
      grimblast = pkgs.grimblast.override {
        hyprland = config.wayland.windowManager.hyprland.finalPackage;
      };
      discord = config.programs.discord.launch_command;
      firefox = lib.getExe config.programs.firefox.finalPackage;
      music = lib.getExe pkgs.youtube-music;
      foot =
        if config.programs.foot.server.enable then
          "${config.programs.foot.package}/bin/footclient"
        else
          "${config.programs.foot.package}/bin/foot";
      emacs =
        if config.services.emacs.enable then
          pkgs.writeShellScript "emacsclient" ''
            if ! ${pkgs.systemd}/bin/systemctl --user status emacs.service >/dev/null 2>&1; then
               ${pkgs.systemd}/bin/systemctl --user start emacs.service
            fi
            ${config.services.emacs.package}/bin/emacsclient --no-wait --reuse-frame "$@"
          ''
        else
          "${config.programs.emacs.finalPackage}/bin/emacs";
      # testing
      term = if true then "${emacs} --eval '(eshell)'" else foot;
    in
    [
      # figure out pyprland scratchpads and use that
      "${mod}, Space,    exec, ${foot}"
      "${mod}, KP_Enter, exec, ${term}"
      "${mod}, Return,   exec, ${term}"
      "${mod}, E,        exec, ${emacs}"
      "${mod}, D,        exec, ${discord}"
      "${mod}, M,        exec, ${music}"
      "${mod}, F,        exec, ${firefox}"
      "${mod}, S,        exec, ${grimblast}/bin/grimblast --freeze copy area"
      ",            PRINT,    exec, ${grimblast}/bin/grimblast --freeze copy screen"
    ];

  workspaces =
    (builtins.concatMap (x: [
      "${mod},       ${if x == 10 then "0" else toString x}, workspace,       ${toString x}"
      "${mod} SHIFT, ${if x == 10 then "0" else toString x}, movetoworkspace, ${toString x}"
    ]) (lib.range 1 10))
    ++ [
      "${mod},       grave, togglespecialworkspace"
      "${mod} SHIFT, grave, movetoworkspace, special"
    ]
    ++ [
      "${mod}, mouse_down, workspace, e+1"
      "${mod}, mouse_up,   workspace, e-1"
    ];

  mouse = [
    "${mod}, mouse:272, movewindow"
    "${mod}, mouse:273, resizewindow"
  ];

  fnKeys =
    let
      notif = lib.getExe pkgs.libnotify;
      volStep = "5%";
      briStep = "5%";
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      brictl = lib.getExe pkgs.brightnessctl;
      playctl = lib.getExe pkgs.playerctl;
    in
    # TODO: better notifs
    [
      ", XF86AudioRaiseVolume, exec, ${pkgs.writeShellScript "volup" ''
        ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${volStep}+
        ${notif} "Volume +${volStep}"
      ''}"
      ", XF86AudioLowerVolume, exec, ${pkgs.writeShellScript "voldown" ''
        ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${volStep}-
        ${notif} "Volume -${volStep}"
      ''}"
      ", XF86AudioMute, exec, ${pkgs.writeShellScript "volmut" ''
        ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
        ${notif} "Volume Muted"
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
      "${mod}, P, exec, ${pkgs.writeShellScript "playtoggle" ''
        if ${playctl} -a status | grep -q "Playing"; then
          ${playctl} -a pause
          ${notif} "Paused All"
        else
          ${playctl} play # play first
          ${notif} "Resuming: $(${playctl} -l | head -n 1)"
        fi
      ''}"
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
  };
}
