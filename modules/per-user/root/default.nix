{
  flake.nixosModules.root-user = {
    users.users.root = {
      initialHashedPassword = "";
    };
  };
}
