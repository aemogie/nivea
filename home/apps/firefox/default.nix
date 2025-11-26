{ pkgs, inputs, ... }@args:
let
  profile = {
    name = "dev-edition-default";
    id = 0;
    settings =
      (import ./preferences.nix args)
      // {
        "browser.uiCustomization.state" = builtins.toJSON (import ./ui.nix);
      }
      // (if true then import ./privacy.nix else { });
    search = {
      force = true;
      default = "magic";
      engines = {
        "magic" = {
          urls = [
            { template = "https://lite.duckduckgo.com/lite/?q={searchTerms}"; }
            {
              template = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
              type = "application/x-suggestions+json";
            }
          ];
        };
        # disable "This time, search with" (part 2, see preferences.nix for rest)
        "Google".metaData.hidden = true;
        "Bing".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Amazon.com".metaData.hidden = true;
      };
    };
    extensions = [
      (import ./theme.nix args)
    ];
  };
in
{
  programs.firefox = {
    enable = true;
    package = inputs.nixpkgs2.legacyPackages.${pkgs.system}.firefox-devedition;
    profiles.default = profile;
    profiles.old.id = 1;
    profiles.work = profile // {
      name = "work";
      id = 2;
    };
  };
}
