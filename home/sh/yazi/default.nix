{ ... }@args:
{
  programs.yazi = {
    enable = true;
    theme = import ./theme.nix args;
  };
  programs.nushell.extraConfig = ''
    def --env ya [args?] {
      let tmp = (mktemp -t "yazi-cwd.XXXXX")
      if ($args == null) {
        yazi --cwd-file $tmp
      } else {
        yazi $args --cwd-file $tmp
      }
      let cwd = (open $tmp)
      if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
      }
      rm -pf $tmp
    }
  '';
}
