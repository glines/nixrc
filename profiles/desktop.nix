{ config, pkgs, ... }:

{
  imports = [
#    # libswc launch service (Wayland compositor)
#    ../services/wayland/swc-launch.nix
    # Experimental X11 + Wayland display configuration
#    ../services/display/default.nix
  ];

  services.rogue.enable = true;

  # Enable Adobe Flash player
  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      jre = false;
      enableGoogleTalkPlugin = false;
      enableAdobeFlash = true;  # FIXME: Do I even care about Adobe flash?
    };
#    chromium = {
#      jre = true;
#      enableGoogleTalkPlugin = true;
#      enablePepperFlash = true;
#      enablePepperPDF = true;
#    };
  };

  environment.systemPackages = with pkgs; [
    anki
    briss
#    calibre
    chromium
    cmus
    conky  # TODO: configure conky
#    dina  # TODO: write a package for dina fonts
    dmenu
#    dmenu-wl
    # install patched version of dwm
    (lib.overrideDerivation pkgs.dwm (attrs: {
      name = "dwm-6.0-patched";
      src = fetchurl {
        url = "https://github.com/auntieNeo/dwm/archive/e7d079df7024379b50c520f14f613f0c036153b1.tar.gz";
        sha256 = "5415d2fe5458165253e047df434a7840d5488f8a60487a05c00bb4f38fe4843f";
      };
    }))
#    ebview
    evince
    firefox
#    freerdp
# FIXME: fix freerdp:
# ####### Building extension hunspell #######
# Compiling hunspell
# CMake Warning at CMakeLists.txt:623 (export):
#   Cannot create package registry file:
#
#       /homeless-shelter/.cmake/packages/freerdp/7efaf6cf5b6fe0c4d9dd6288e45784d3
#
    ghostscript
    gnumeric
#    go-mtpfs
    gparted
    graphviz
    gutenprint
#    ibus
    imagemagick
#    ipafont  # FIXME: The download link is dead
#    jmtpfs
    # kochi_substitute  # TODO: write a kochi substitute package
    mplayer
    mtpfs
    networkmanagerapplet
    nitrogen
    openbox
    openjdk
#    pdfjam
    pdftk
    scrot
#    st-wl
    texlive.combined.scheme-full
    typespeed
    # Install a patched version of rxvt_unicode (with text shadows).
    (lib.overrideDerivation pkgs.rxvt_unicode (attrs: {
      patches = [ ../patches/urxvt-text-shadows.patch ];  # FIXME: This clobbers an existing patch for correct font spacing.
    }))
# FIXME: fix freerdp to fix weston
#    weston
    wineStaging
    wmname  # Used for hack in which Java apps break in dwm.
    x11vnc
    xlibs.xinit
    xorg.xkill
#    xwayland  # FIXME: conflict with xorg man page
  ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      anthy
      mozc
    ];
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      ipafont  # Japanese characters
      dina-font  # Programming font
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable 3D acceleration for 32bit applications (e.g. wine)
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbVariant = "dvorak";
#    xkbOptions = "caps:hyper";
    enableCtrlAltBackspace = true;

#    displayManager = {
#      slim = {
#        # Set the SLiM display manager theme.
#        theme = pkgs.fetchurl {
#          url = "https://github.com/menski/slim-theme-dwm/archive/076038e839a29fad3ec403326c22f0cf3e7c79f9.tar.gz";
#          sha256 = "d74fb764cb79f962d7bdb134388b9d8a31dbbb67953adc5c54a14b85aaf73d9f";
#        };
#
##        # Auto-login until I get a less ugly theme
##        defaultUser = "auntieneo";
##        autoLogin = true;
#      };
#
#      # Set key repeat delay lower than default (which is 500 30).
#      xserverArgs = [
#        "-ardelay 400"
#        "-arinterval 30"
#      ];
#
#      # Set dwm as the X session type.
#      session = [ {
#        manage = "window";
#        name = "dwm";
#        start = ''
#          wmname LG3D
#          # FIXME: Need a way to reference the patched dwm by its full path.
#          dwm
#          waitPID=$!
#        '';
#      } ];
#    };

    # Enable dwm window manager.
#    windowManager.default = "dwm";

    desktopManager.plasma5.enable = true;
    displayManager.auto = {
      enable = true;
      user = "auntieneo";
    };
  };

#  # Enable swc+velox (Wayland compositor) as alternative to X11
#  services.swc-launch = {
#    enable = true;
#    user = "auntieneo";
#    layout = "dvorak";
#    xkbOptions = "caps:super";
#    server.velox.enable = true;
#  };

#  # The following is a prototype of possible config options for
#  # services.display module. The complexity of this example is
#  # intended to exercise all of the possibilities.
#  #
#  # Possible options vary depending on the value of the "type" option. This
#  # variation is achieved with simple duck-typed polymorphism, a.k.a. the
#  # honor system.
#  services.display = {
#    enable = true;
#    layout = "dvorak";
#    xkbOptions = "caps:super";
#    displayManager = {
#      wayland.swc-launch = {
#        enable = true;
#        user = "auntieneo";
#      };
#
#      sessions = [
#        {
#          # The Wayland case is (nearly) always this simple.
#
#          # More sophisticated options (as with X11) are possible, but most
#          # Wayland desktop environments are tightly integrated with the window
#          # manager, so these options (outside of user-defined scripts) are
#          # limited.
#
#          name = "Velox";
#          type = "wayland.velox";
#          script = ''
#            ${pkgs.st-wl}/bin/st-wl
#            '';
#        }
#        {
#          # The simple X11 case is similar to the Wayland case.
#          # The only addition is that a desktop manager should (must?) be
#          # specified.
#          name = "Gnome 3";
#          type = "x11.mutter";
#          desktop-manager.type = "x11.gnome3";
#        }
#        {
#          # A pseudo-session called x11.combination is provided to emulate the
#          # old behavior of generating the combination of any given X11 window
#          # manager with any given X11 desktop manager.
#          type = "x11.combination";
#          window-managers = [
#            # These "window managers" are also valid X11 sessions (such as the
#            # "x11.mutter" session type used above).
#            {
#              name = "Fluxbox";
#              type = "x11.fluxbox";
#            }
#            {
#              name = "Openbox";
#              type = "x11.openbox";
#            }
#            {
#              name = "IceWM";
#              type = "x11.icewm";
#            }
#          ];
#          desktop-managers = [
#            # These "desktop managers" are not useful in the Wayland paradigm,
#            # but are analogous to the "script" option for Wayland sessions.
#
#            # Any of these desktop managers can also be used in the simple X11
#            # case (see "desktop-manager.type" above).
#            {
#              name = "KDE 4";
#              type = "kde4";
#            }
#            {
#              name = "xterm";
#              type = "script";
#              script = ''
#                xterm &
#                waitPID=$!
#              '';
#            } ];
#        }
#      ];
#    };
#    session.velox.enable = true;
#  };

#  # my display configuration
#  services.display = {
#    enable = true;
#    layout = "dvorak";
#    xkbOptions = "caps:super";
#    displayManager = {
#      wayland.swc-launch = {
#        enable = true;
#        user = "auntieneo";
#      };
#      sessions = [
#        {
#          name = "Velox";
#          type = "wayland.velox";
#          script = ''
#            ${pkgs.st-wl}/bin/st-wl
#            '';
#        }
#      ];
#    };
#  };

#  # weston display configuration
#  services.display = {
#    enable = true;
#    layout = "dvorak";
#    xkbOptions = "caps:super";
#    displayManager = {
#      wayland.weston-launch = {
#        enable = true;
#        user = "auntieneo";
#      };
#      sessions = [
#        {
#          name = "Weston";
#          type = "wayland.weston";
#        }
#      ];
#    };
#  };

  # TODO: push these upstream
  # FIXME: need to bump version of libinput
  nixpkgs.config.packageOverrides = pkgs: rec {
#    libswc = pkgs.misc.debugVersion (pkgs.callPackage ../pkgs/libswc/default.nix { });
#    libwld = pkgs.callPackage ../pkgs/libwld/default.nix { };
#    velox = pkgs.callPackage ../pkgs/velox/default.nix { };
#    dmenu-wl = pkgs.callPackage ../pkgs/dmenu-wl/default.nix { };
#    st-wl = pkgs.callPackage ../pkgs/st-wl/default.nix { };
    ebview = pkgs.misc.debugVersion (pkgs.callPackage ../pkgs/ebview/default.nix { });
    libeb = pkgs.callPackage ../pkgs/libeb/default.nix { };
#    mesa_drivers = pkgs.pkgs.mesaDarwinOr (
#      let mo = pkgs.mesa_noglu.override {
#        llvmPackages = pkgs.llvmPackages_36;
#      };
#    in mo.drivers);
  };
}
