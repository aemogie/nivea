{ pkgs, ... }:
{
  programs = {
    git.ignores = [ ".direnv/" ];
    direnv = {
      enable = true;
      package = pkgs.symlinkJoin {
        inherit (pkgs.direnv) meta;
        name = "direnv-nolog";
        paths = [ pkgs.direnv ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/direnv --set DIRENV_LOG_FORMAT ""
        '';
      };
      nix-direnv.enable = true;
      stdlib = ''
        use_guix() {
            local cache_dir="$(direnv_layout_dir)/.guix-profile"
            local guix="$(which guix)"
            if [[ -f channels.lock.scm ]]; then
                log_status "using lockfile channels.lock.scm"
                guix="$guix time-machine -C channels.lock.scm -- "
            elif [[ -f channels.scm ]]; then
                log_status "lockfile not found, but channels.scm found. creating lockfile"
                tmplock="$(mktemp)"
                $guix time-machine -C "$CHANNEL_FILE" -- describe -f channels >"$tmplock" && \
                    # only overrwrite if succeeded
                    cat "$tmplock" > "$LOCK_FILE" && \
                    guix="$guix time-machine -C channels.lock.scm -- "
                rm -f "$tmplock"
            fi

            if [[ -e "$cache_dir/etc/profile" ]]; then
                log_status "using cached profile"
                # shellcheck disable=SC1091
                source "$cache_dir/etc/profile"
            else
                log_status "no cached profile found. calling out to guix."
                mkdir -p "$(direnv_layout_dir)"
                eval "$($guix shell --search-paths --root="$cache_dir" "$@")"
            fi
        }
      '';
    };
  };
}
