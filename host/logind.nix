{
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
  };
  # here cz idk where else
  security.pam.services.swaylock.text = "auth include login";
}
