{ pkgs, ... }@args:
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
            { template = "https://html.duckduckgo.com/html/?q={searchTerms}"; }
            {
              template = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
              type = "application/x-suggestions+json";
            }
          ];
        };
        # disable "This time, search with" (part 2, see preferences.nix for rest)
        "google".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "ddg".metaData.hidden = true;
        "wikipedia".metaData.hidden = true;
        "ebay".metaData.hidden = true;
        "amazondotcom-us".metaData.hidden = true;
        "perplexity".metaData.hidden = true;
      };
    };
    extensions.packages = [
      (import ./theme.nix args)
    ];
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.default = profile;
    profiles.old.id = 1;
    profiles.work = profile // {
      name = "work";
      id = 2;
    };
  };
}
