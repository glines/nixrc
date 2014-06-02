{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    anki
#    anthy  # TODO: write an anthy package (with ibus)
    chromium
    conky
#    dina  # TODO: write a package for dina fonts
    dmenu
    # install patched version of dwm
    (pkgs.lib.overrideDerivation pkgs.dwm (attrs: {
      name = "dwm-6.0-patched";
      src = fetchurl {
        url = "https://github.com/auntieNeo/dwm/archive/e7d079df7024379b50c520f14f613f0c036153b1.tar.gz";
        sha256 = "5415d2fe5458165253e047df434a7840d5488f8a60487a05c00bb4f38fe4843f";
      };
    }))
    evince
    gutenprint
    # kochi_substitute  # TODO: write a kochi substitute package
    mplayer
    netbeans
    # Install a patched version of rxvt_unicode (with text shadows).
    (pkgs.lib.overrideDerivation pkgs.rxvt_unicode (attrs: {
      patches = [ ../patches/urxvt-text-shadows.patch ];  # FIXME: This clobbers an existing patch for correct font spacing.
    }))
    wmname  # Used for hack in which Java apps break in dwm.
    xlibs.xinit
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "dvorak";
    xkbOptions = "caps:hyper";

    displayManager = {
      # Set the SLiM display manager theme.
      slim.theme = pkgs.fetchurl {
        url = "https://github.com/menski/slim-theme-dwm/archive/076038e839a29fad3ec403326c22f0cf3e7c79f9.tar.gz";
        sha256 = "d74fb764cb79f962d7bdb134388b9d8a31dbbb67953adc5c54a14b85aaf73d9f";
      };

      # Set key repeat delay lower than default (which is 500 30).
      xserverArgs = [
        "-ardelay 400"
        "-arinterval 30"
      ];

      # Set dwm as the X session type.
      session = [ {
        manage = "window";
        name = "dwm";
        start = ''
          # FIXME: Need a way to reference the patched dwm by it's full path.
          dwm
          waitPID=$!
        '';
      } ];
    };

#    # Enable dwm window manager.
#    windowManager.dwm = { enable = true; };

  };
}
