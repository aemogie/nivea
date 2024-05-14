{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeCBin "runbg" ''
      #include <unistd.h>
      #include <fcntl.h>

      int main(int argc, char *argv[]) {
          if (fork() == 0) {
              int null_fd = open("/dev/null", O_WRONLY);
              dup2(null_fd, STDOUT_FILENO);
              dup2(null_fd, STDERR_FILENO);
              execvp(argv[1], &argv[1]);
              return -1;
          }

          return 0;
      }
    '')
  ];
  home.shellAliases.r = "runbg";
}
