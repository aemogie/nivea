{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeCBin "runbg" ''
      #include <stdio.h>
      #include <unistd.h>
      #include <fcntl.h>

      int main(int argc, char *argv[]) {
          if (argc < 2) {
              fprintf(stderr, "usage: %s <program> [args...]\n", argv[0]);
              return 1;
          }

          if (fork() == 0) {
              int null_fd = open("/dev/null", O_WRONLY);
              dup2(null_fd, STDOUT_FILENO);
              dup2(null_fd, STDERR_FILENO);
              
              execvp(argv[1], &argv[1]);
              // not sure but probably the error
              fprintf(stderr, "error: could not find '%s'", argv[1]);
          }

          return 0;
      }
    '')
  ];
  home.shellAliases.r = "runbg";
}
