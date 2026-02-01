{ pkgs, ... }:
{
  config.programs = {
    git = {
      enable = true;
      settings = {
        user.name = "aemogie";
        user.email = "theaemogie" + "@" + "gmail.com";
        init.defaultBranch = "dev";
        commit.gpgsign = true;
        gpg = {
          # format = "ssh";
          # thanks to
          # https://www.reddit.com/r/git/comments/1coropv/comment/l3mwfso/
          ssh.program = "${pkgs.writeShellScript "ssh-auto-add" ''
            while getopts Y:n:f: opt; do case $opt in
                f) ${pkgs.openssh}/bin/ssh-add -T "$OPTARG" 2>&- || ssh-add "$OPTARG" ;;
            esac; done

            exec ${pkgs.openssh}/bin/ssh-keygen "$@"
          ''}";
        };
        # user.signingkey = "~/.ssh/id_ed25519";
      };
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
