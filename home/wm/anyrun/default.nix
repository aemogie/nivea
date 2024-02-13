{
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  bgalpha = 0.6; # make into module option
in {
  imports = [inputs.anyrun.homeManagerModules.default];

  programs.anyrun = {
    enable = true;

    config = {
      plugins = with (inputs.anyrun.packages.${pkgs.system}); [
        applications
        rink
        shell
        translate
        websearch
      ];

      # width.fraction = 0.4;
      y.fraction = 0.2;
      hidePluginInfo = true;
      closeOnClick = true;
      maxEntries = 10;
      showResultsImmediately = true;
    };

    extraCss =
      #css (from github:n3oney/nixus)
      ''
        window {
          background: transparent; /* rgba(0, 0, 0, 0.8);*/
        }

        * {
          transition: 200ms ease;
          font-family: "Iosveka Aile"; /* use some system font config */
        }

        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        #match.activatable {
          padding: 12px 14px;
          border-radius: 12px;

          color: white;
          margin-top: 4px;
          border: 2px solid transparent;
          transition: all 0.3s ease;
        }

        #match.activatable:not(:first-child) {
          border-top-left-radius: 0;
          border-top-right-radius: 0;
          border-top: 2px solid rgba(255, 255, 255, 0.1);
        }

        #match.activatable #match-title {
          font-size: 1.3rem;
        }

        #match.activatable:hover {
          border: 2px solid rgba(255, 255, 255, 0.4);
        }

        #match-title, #match-desc {
          color: inherit;
        }

        #match.activatable:hover, #match.activatable:selected {
          border-top-left-radius: 12px;
          border-top-right-radius: 12px;
        }

        #match.activatable:selected + #match.activatable, #match.activatable:hover + #match.activatable {
          border-top: 2px solid transparent;
        }

        #match.activatable:selected, #match.activatable:hover:selected {
          background: rgba(255,255,255,0.1);
          border: 2px solid rgba(203, 166, 247, 0.7);
          border-top: 2px solid rgba(203, 166, 247, 0.7);
        }

        #match, #plugin {
          box-shadow: none;
        }

        #entry {
          color: white;
          box-shadow: none;
          border-radius: 12px;
          border: 2px solid rgba(203, 166, 247, 0.7);
        }

        box#main {
          background: rgba(36, 39, 58, ${toString bgalpha});
          border-radius: 16px;
          padding: 8px;
          box-shadow: 0px 2px 33px -5px rgba(0, 0, 0, 0.5);
        }

        row:first-child {
          margin-top: 6px;
        }
      '';

    extraConfigFiles."shell.ron".text =
      #ron
      ''Config(prefix: ">")'';
  };
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur,^anyrun$"
    "ignorealpha ${toString (bgalpha - 0.1)},^anyrun$"
  ];
}
