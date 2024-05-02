{
  config,
  osConfig,
  pkgs,
  lib,
  isVm,
  ...
}:
let
  notify-send = lib.getExe pkgs.libnotify; # todo: implement notifications, possibly with an abstraction
  main_mod = "SUPER";
  bind =
    {
      mods ? "",
      key,
      action,
      args ? "",
    }:
    "${mods},${key},${action}${if args == "" then "" else ",${args}"}";
  bind' =
    mods: key: action:
    let
      consume_args =
        let
          go = acc: arg: if arg == null then acc else null;
        in
        arg: "${arg} ${consume_args}";
    in
    null;

  basic = [
    # (bind {
    #   mods = main_mod;
    #   key = "Q";
    #   action = "exit";
    # })
    (bind {
      mods = main_mod;
      key = "Q";
      action = "killactive";
    })
    (bind {
      mods = main_mod;
      key = "V";
      action = "togglefloating";
    })
    (bind {
      mods = main_mod;
      key = "O";
      action = "fullscreen";
      args = "1";
    })
    (bind {
      mods = main_mod;
      key = "T";
      action = "layoutmsg";
      args = "togglesplit";
    })
  ];

  launch_app =
    let
      inherit (pkgs) grimblast;
      anyrun = config.programs.anyrun.package;
      firefox = lib.getExe config.programs.firefox.finalPackage;
      foot = lib.getExe config.programs.foot.package;
    in
    [
      (bind {
        mods = main_mod;
        key = "Space";
        action = "exec";
        args = "pkill anyrun || ${anyrun}/bin/anyrun";
      })
      (bind {
        mods = main_mod;
        key = "KP_Enter";
        action = "exec";
        args = foot;
      })
      (bind {
        mods = main_mod;
        key = "Return";
        action = "exec";
        args = foot;
      })
      (bind {
        mods = main_mod;
        key = "D";
        action = "exec";
        args = config.programs.discord.launch_command;
      })
      (bind {
        mods = main_mod;
        key = "F";
        action = "exec";
        args = firefox;
      })
      # (bind {
      #   mods = main_mod;
      #   key = "M";
      #   action = "exec";
      #   args = "${spotify}/bin/spotify";
      # })
      (bind {
        mods = main_mod;
        key = "S";
        action = "exec";
        args = "${grimblast}/bin/grimblast --freeze copy area";
      })
      (bind {
        key = "PRINT";
        action = "exec";
        args = "${grimblast}/bin/grimblast --freeze copy screen";
      })
    ];

  focus_move = [
    (bind {
      mods = main_mod;
      key = "H";
      action = "movefocus";
      args = "l";
    })
    (bind {
      mods = main_mod;
      key = "J";
      action = "movefocus";
      args = "d";
    })
    (bind {
      mods = main_mod;
      key = "K";
      action = "movefocus";
      args = "u";
    })
    (bind {
      mods = main_mod;
      key = "L";
      action = "movefocus";
      args = "r";
    })
  ];

  workspaces =
    let
      allWokspaces =
        map:
        builtins.genList (
          x:
          let
            key = if x + 1 == 10 then 0 else x + 1;
          in
          map (toString key) (toString (x + 1))
        ) 10;
    in
    {
      switch =
        (allWokspaces (
          key: args:
          bind {
            inherit key args;
            mods = main_mod;
            action = "workspace";
          }
        ))
        ++ [
          (bind {
            key = "grave";
            mods = main_mod;
            action = "togglespecialworkspace";
          })
        ];
      move =
        (allWokspaces (
          key: args:
          bind {
            inherit key args;
            mods = "${main_mod} SHIFT";
            action = "movetoworkspace";
          }
        ))
        ++ [
          (bind {
            key = "grave";
            mods = "${main_mod} SHIFT";
            action = "movetoworkspace";
            args = "special";
          })
        ];

      scroll = [
        (bind {
          mods = main_mod;
          key = "mouse_down";
          action = "workspace";
          args = "e+1";
        })
        (bind {
          mods = main_mod;
          key = "mouse_up";
          action = "workspace";
          args = "e-1";
        })
      ];
    };

  mouse = [
    (bind {
      mods = main_mod;
      key = "mouse:272";
      action = "movewindow";
    })
    (bind {
      mods = main_mod;
      key = "mouse:273";
      action = "resizewindow";
    })
  ];

  volume =
    let
      step = "5%";
      notify-volume-up = pkgs.writeShellScript ''${notify-send} "Volume +${step}"'';
      notify-volume-down = pkgs.writeShellScript ''${notify-send} "Volume -${step}"'';
      pipewire =
        let
          wpctl = "${pkgs.wireplumber}/bin/wpctl";
        in
        {
          up_down = [
            (bind {
              key = "XF86AudioRaiseVolume";
              action = "exec";
              args = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${step}+ && ${notify-volume-up}";
            })
            (bind {
              key = "XF86AudioLowerVolume";
              action = "exec";
              args = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${step}- && ${notify-volume-up}";
            })
          ];
          mute = [
            (bind {
              key = "XF86AudioMute";
              action = "exec";
              args = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            })
          ];
        };
      pulse =
        let
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
        {
          up_down = [
            (bind {
              key = "XF86AudioRaiseVolume";
              action = "exec";
              args = "${pactl} set-sink-volume @DEFAULT_SINK@ +${step}";
            })
            (bind {
              key = "XF86AudioLowerVolume";
              action = "exec";
              args = "${pactl} set-sink-volume @DEFAULT_SINK@ -${step}";
            })
          ];
          mute = [
            (bind {
              key = "XF86AudioMute";
              action = "exec";
              args = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
            })
          ];
        };
    in
    pulse;
  brightness =
    let
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in
    [
      (bind {
        key = "XF86MonBrightnessUp";
        action = "exec";
        args = "${brightnessctl} set +5%";
      })
      (bind {
        key = "XF86MonBrightnessDown";
        action = "exec";
        args = "${brightnessctl} set 5%-";
      })
    ];
  player =
    let
      playerctl = lib.getExe pkgs.playerctl;
    in
    [
      (bind {
        key = "XF86AudioPlay";
        action = "exec";
        args = "${playerctl} play-pause";
      })
      (bind {
        key = "XF86AudioPrev";
        action = "exec";
        args = "${playerctl} previous";
      })
      (bind {
        key = "XF86AudioNext";
        action = "exec";
        args = "${playerctl} next";
      })
    ];
in
{
  wayland.windowManager.hyprland.settings = {
    bind =
      basic
      ++ launch_app
      ++ focus_move
      ++ workspaces.switch
      ++ workspaces.move
      ++ workspaces.scroll
      ++ volume.mute
      ++ brightness
      ++ player;

    binde = volume.up_down;
    bindm = mouse;
  };
  lib.hyprkeys = {
    inherit
      basic
      launch_app
      focus_move
      workspaces
      volume
      brightness
      player
      mouse
      ;
  };
}
