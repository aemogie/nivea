def e [cwd: path = .] {
  cd ($cwd | path expand)
  if ZELLIJ in $env {
    @z_editor_tab@
  } else {
    @z_editor_new@
  }
}
