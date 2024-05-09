def --wrapped r [
  program: string,
  ...args: string,
  --no-expand (-n), # Relative paths don't work with the `exec` dispatcher. Enable this flag to disable path expansion.
] {
  let p = (which -a $program)
  if (not ($p | is-empty)) and ("external" in $p.type) {
    let program = ($p | where type == external | first).path;
    if ($no_expand) {
      @hyprctl@ dispatch exec $"($program) ($args | str join ' ')" | ignore
    } else {
      let args = ($args | each {
        if ($in | path exists) {
          $in | path expand
        } else { $in }
      })
      @hyprctl@ dispatch exec $"($program) ($args | str join ' ')" | ignore
    }
  } else {
    error make {
      msg: "program not found",
      label: {
        text: $"could not found program `($program)`!",
        span: (metadata $program).span
      }
    }
  }
}

def e [cwd: path = .] {
  cd ($cwd | path expand)
  if ZELLIJ in $env {
    @z_editor_tab@
  } else {
    @z_editor_new@
  }
}
