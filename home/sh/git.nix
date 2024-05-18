{
  pkgs,
  lib,
  config,
  ...
}:
let
  git = lib.getExe pkgs.git;
  git-with-status = pkgs.writeShellScript "git-with-status" ''
    if [ $# -eq 0 ]; then
      ${git} status
    else
      ${git} "$@"
    fi
  '';
  aliases = {
    "c" = "commit -m";
    "a" = "add";
    "ap" = "add --patch";
    "s" = "switch";
    "p" = "push";
    "pf" = "push --force-with-lease";
    "d" = "diff";
    "sh" = "show --ext-diff";
    "l" = "log --oneline";
  };
  cfg = config.apps.git;
in
{
  options.apps.git = {
    commonAliases = lib.mkEnableOption "some common git aliases";
    # TODO: carapace stops autocompleting. enable this by default when fixed
    showStatusOnNoop = lib.mkEnableOption "git status on noop";
  };
  config.home.shellAliases =
    lib.optionalAttrs cfg.commonAliases (
      lib.concatMapAttrs (alias: _: { "g${alias}" = "${git} ${alias}"; }) aliases
    )
    // lib.optionalAttrs cfg.showStatusOnNoop { "git" = "${git-with-status}"; };

  config.programs = {
    git = {
      enable = true;
      userName = "aemogie";
      userEmail = "54412618+aemogie@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "dev";
        commit.gpgsign = true;
        gpg = {
          format = "ssh";
          ssh.program = toString (
            # thanks to
            # https://www.reddit.com/r/git/comments/1coropv/comment/l3mwfso/
            pkgs.writeShellScript "ssh-auto-add" ''
              while getopts Y:n:f: opt; do case $opt in 
                  f) ${pkgs.openssh}/bin/ssh-add -T "$OPTARG" 2>&- || ssh-add "$OPTARG" ;;
              esac; done

              exec ${pkgs.openssh}/bin/ssh-keygen "$@"
            ''
          );
        };
        user.signingkey = "~/.ssh/id_ed25519";
      };
      difftastic.enable = true;
      aliases = lib.mkIf cfg.commonAliases aliases;
    };
    gh = {
      enable = true;
      settings.version = 1; # nix-community/home-manager#4744
      settings.git_protocol = "ssh";
      gitCredentialHelper.hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
  };
}
