# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma 6 on X11
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.defaultSession = "plasmax11";

  services.displayManager.sddm.wayland.enable = false;  # disable wayland in sddm

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.rocco = {
    isNormalUser = true;
    description = "Rocco";
    extraGroups = [ "networkmanager" "wheel" "bluetooth" "libvirtd" "adbusers" "kvm" ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Generic Linux binaries (needed for Android Studio / emulator)
  programs.nix-ld.enable = true;

  # Virtualization for Android Studio emulator
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # zen-browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # terminal
    kitty

    xclip
    xsel

    xdg-utils
    inotify-tools
    python3
    git

    kdePackages.spectacle   # KDE screenshot tool
    scrot       # CLI fallback

    # file manager
    kdePackages.dolphin

    # media/audio
    playerctl
    brightnessctl
    wireplumber

    # utils
    jq
    curl

    # custom cursor
    phinger-cursors

    # fetch
    fastfetch

    # tasks
    btop
    htop

    # app store / flatpak
    gnome-software

    # ssl
    openssl

    # android studio + tools
    android-studio
    android-tools

    gsettings-desktop-schemas
    glib

    # terminal theme
    starship
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "phinger-cursors-dark";
    XCURSOR_SIZE = "24";
    ANDROID_EMULATOR_USE_SYSTEM_LIBS = "1";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.dbus.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot.kernelModules = [ "btusb" "kvm-amd" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  hardware.graphics.enable = true;

  # Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  programs.nix-ld.libraries = with pkgs; [
    libX11
    libXext
    libXrender
    libXtst
    libXi
    libXfixes
    libXcursor
    libXrandr
    libXdamage
    libXcomposite
    libxcb
    xcbutil
    xcbutilcursor
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    libxkbfile
    libGL
    vulkan-loader
    libdrm
    mesa
    libpulseaudio
    alsa-lib
    gtk3
    cairo
    pango
    fontconfig
    freetype
    libpng
    glib
    dbus
    expat
    zlib
    zstd
    util-linux
    libsecret
    nss
    stdenv.cc.cc.lib
    sqlite
    libunwind
    udev
    systemd
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
