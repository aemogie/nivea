{
  flake.modules.nixos.root-user = {
    users.users.root = {
      initialHashedPassword = "";
    };
  };
}
