{ config, pkgs, ... }:

{
  system.stateVersion = "23.11";
  imports = [ 
    ./hardware-configuration.nix          
  ];

  # overlays
  nixpkgs.overlays = [    
    (self: super: 
      {        
          speechd = "";		       
      }
    )
  ];
  
  # powerManagement.cpuFreqGovernor = "performance"; 
  # Often used values: “ondemand”, “powersave”, “performance”

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev"; # change with your storage device id
  boot.loader.grub.useOSProber = true;  
  boot.loader.grub.theme = pkgs.nixos-grub2-theme;
  
  #boot.loader.grub.extraEntriesBeforeNixOS = true;
  #boot.loader.grub.timeoutStyle = "hidden";
  #boot.plymouth.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # video driver
  #services.xserver.videoDrivers = [ ];
  #nixpkgs.config.nvidia.acceptLicense = true;   
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  #hardware.nvidia.modesetting.enable = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # virtual camera
  # Make some extra kernel modules available to NixOS
  boot.extraModulePackages = with config.boot.kernelPackages;[ v4l2loopback.out ];  
  boot.kernelModules = [ "v4l2loopback" ];  
  boot.extraModprobeConfig = '' options v4l2loopback exclusive_caps=1 card_label="Virtual Camera" '';
  
  #zram
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;  
  
  #filesystem
  boot.supportedFilesystems = [
      "btrfs"
      "ntfs"
      "fat32"
      "exfat"
  ];  

  # waydroid
  #virtualisation = {
    #waydroid.enable = true;
    #lxd.enable = true;
    #lxc.enable = true;
  #};

  # lxc
  #virtualisation.lxc.defaultConfig = ''
    #lxc.net.0.type = veth
    #lxc.net.0.link = lxdbr0
    #lxc.net.0.flags = up
  #'';

  # docker
  virtualisation.docker.enable = true;
   
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.hostName = "NixOS"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # ENV
  environment.variables = {
    "WLR_NO_HARDWARE_CURSORS" = "1";
    #"WLR_RENDERER" = "pixman";
    #"WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    #"LIBGL_ALWAYS_SOFTWARE" = "1";
  };

  # Fonts  
  #fonts.packages = with pkgs; [ nerdfonts ];

  # gvfs 
  services.gvfs.enable = true;

  # picom
  services.picom.enable = false;
  services.picom.fade = true;
  services.picom.shadow = false;
  services.picom.shadowExclude = [
    "window_type *= 'toolbar'"
    "window_type *= 'dock'"
    "window_type *= 'desktop'"
  ];  
  #services.picom.fadeExclude = [ 
  #  "window_type *= 'menu'"
  #];
  #services.picom.fadeSteps = [
  #  0.04
  #  0.04
  #];  
  

  # Enable the X11 display server.
  services.xserver.enable = true;

  # Login Manager.
  services.xserver.displayManager.lightdm.enable = true;

  # window manager
  # swaywm
    #programs.sway.enable = true;  
    #programs.sway.extraPackages = with pkgs; [
    #  waybar rofi slurp grim wf-recorder
    #  fuzzel foot
    #];

  # hypr
  #services.xserver.windowManager.hypr.enable = true;

  # hyprland
  #programs.hyprland.enable = true;
  #programs.hyprland.enableNvidiaPatches = true;

  # openbox
  #services.xserver.windowManager.openbox.enable = true;

  # Desktop Environtmen
  services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.budgie.enable = true;
  #services.xserver.desktopManager.deepin.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.pantheon.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  
  # plasma5 exclude
  environment.plasma5.excludePackages = with pkgs; [
    libsForQt5.elisa
    libsForQt5.gwenview
    libsForQt5.konsole
    libsForQt5.okular
    libsForQt5.spectacle    
    libsForQt5.ark
    orca
  ];

  # gnome exclude
  services.gnome.evolution-data-server.enable = pkgs.lib.mkForce false;
  services.gnome.gnome-online-accounts.enable = pkgs.lib.mkForce false;
  programs.gnome-terminal.enable = pkgs.lib.mkForce false;
  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-terminal
    gnome.gnome-system-monitor
    gnome.gnome-screenshot
    gnome.gnome-music
    gnome.gnome-keyring
    gnome.file-roller
    gnome.eog
    gnome.yelp
    gnome.totem
    gnome.gedit
    gnome.geary
    gnome.cheese
    orca
    epiphany
    gnome-text-editor
    gnome.nautilus
    gnome.gnome-contacts
    gnome.gnome-weather
    gnome.simple-scan
    gnome-photos
    evince
    gnome.gnome-disk-utility    
    gnome-tour
  ];
  
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.  
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;    
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  
  # editable nix store
  #boot.readOnlyNixStore = false;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [       
    gimp
    inkscape-with-extensions
    chromium google-chrome
    libreoffice-qt jre
    krdc
    krfb
    kget
    pdfarranger
    gparted    
    simplescreenrecorder
    vlc
    xorg.xhost pulseaudio wget onboard ffmpeg_5-full
    xfce.mousepad
    lxde.lxtask htop btop neofetch    
    p7zip     
    git
    baobab
    #winbox  
    docker-compose
  ] ++ (
    if (config.services.xserver.desktopManager.lxqt.enable == true)
    then with pkgs; [
      #libsForQt5.kwin
      #libsForQt5.systemsettings
      #libsForQt5.kglobalaccel
      #libsForQt5.qt5.qttools    
      networkmanagerapplet    
      feh   
    ] else with pkgs; [
      lxqt.screengrab
      lxqt.pavucontrol-qt
      lxqt.qterminal
      lxqt.pcmanfm-qt
      lxmenu-data
      menu-cache    
      lxqt.lximage-qt
      lxqt.lxqt-archiver
      lxqt.lxqt-sudo
      libsForQt5.breeze-icons
    ]
  ) ++ (
    if(config.services.xserver.desktopManager.plasma5.enable == true)
    then with pkgs;[
        libsForQt5.applet-window-buttons
    ] else with pkgs;[

    ]
  ) ++ (
    if(config.services.xserver.windowManager.hypr.enable == true)
    then with pkgs;[
      feh
      polybar
      rofi    
      networkmanagerapplet
      lxappearance
      apple-cursor
      udiskie
      lxqt.lxqt-policykit
      dunst
      libnotify
      volumeicon
      clipit
      gnome.zenity
      numlockx      
      xorg.setxkbmap
    ] else [

    ]
  );

  # iptv
  #services.tvheadend.enable = true;

  #virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # ftp
  #services.vsftpd.enable = true;
  #services.vsftpd.writeEnable =true;
  #services.vsftpd.localUsers = true;
  #services.vsftpd.anonymousUser = false;
  #services.vsftpd.anonymousUserHome = "/home/ftp/";
  #services.vsftpd.anonymousUserNoPassword = true;
  #services.vsftpd.anonymousUploadEnable = true;

  # webserver
  #services.httpd.enable = true;  
  #services.httpd.user = "ramuni";
  #services.httpd.group = "users";
  #services.httpd.enablePerl = true;
  #services.httpd.enablePHP = true;
  #services.httpd.virtualHosts.localhost.documentRoot = "/home/ramuni/Public/";

  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 21 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ramuni = {
    isNormalUser = true;
    description = "Ramuni muni";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [

    ];    
  };

  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
   # Did you read the comment?
  
}
