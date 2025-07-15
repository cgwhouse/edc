{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "virt-nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cristian = {
    isNormalUser = true;
    description = "Cristian Widenhouse";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    nerd-fonts.ubuntu
    nerd-fonts.fira-code

    # VS Code
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        # nix meta
        bbenoist.nix
        kamadorueda.alejandra
        mkhl.direnv

        # .NET
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        ms-dotnettools.vscode-dotnet-runtime
        csharpier.csharpier-vscode

        esbenp.prettier-vscode
      ];
    })
  ];

  # Do not touch
  system.stateVersion = "25.05";

  # VM guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = ["direnv" "extract" "git" "sudo"];
      theme = "eastwood";
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # Enables use of `nix search nixpkgs`
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # direnv for VS Code
  programs.direnv.enable = true;
}
