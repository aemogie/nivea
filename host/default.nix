# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/paint
    ./switch.nix
    ./tty.nix
    ./grub.nix
    ./regreet.nix
    ./plymouth.nix
    ./registry.nix
    ./vaapi.nix
    ./logind.nix
    # ./keyd.nix
    ./battery
    ./hyprland.nix
    ./docs.nix
    # ./syncthing.nix
    ./steam.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "@wheel"
      ];
      # hard link duplicates automatically
      auto-optimise-store = true;
      keep-going = true;
      # sandbox = false;
    };
    # TODO: runs way too often, slow it down
    # gc.automatic = true;
    # TODO: set a maximum generation limit
  };

  services.guix = {
    enable = true;
    extraArgs = [
      "--substitute-urls=${
        lib.concatStringsSep " " [
          "https://ci.guix.gnu.org"
          "https://bordeaux.guix.gnu.org"
          "https://substitutes.nonguix.org"
        ]
      }"
    ];
  };

  services.tailscale.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Colombo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm = {
  # enable = true;
  # wayland = true;
  # };
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [ pkgs.cage ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  virtualisation.waydroid.enable = true;

  # no tofu
  fonts.packages = with pkgs; [
    aporetic
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  services.blueman.enable = true;
  services.sshd.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.gvfs.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;

  system.stateVersion = "23.05";
}
