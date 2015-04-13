{ stdenv, fetchurl, fetchgit, jansson, libxml2, libxslt, ncurses, openssl, sqlite, utillinux }:

stdenv.mkDerivation rec {
  name = "asterisk-${version}";
#  version = "13.2.0";
  version = "git";

#  src = fetchurl {
#    url = "http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${version}.tar.gz";
#    sha256 = "bcef6b30cf7bb1943b12939a4dc98a53f837a8f7ef564fe44cf73ea87e114a9b";
#  };
  src = fetchgit {
    url = file:///home/auntieneo/code/asterisk/git;
    rev = "refs/heads/bla";
    # r!printf '    sha256 = "\%s";' `nix-prefetch-git file:///home/auntieneo/code/asterisk/git --rev refs/heads/bla 2>&/dev/null | tail -n1`
    sha256 = "c44abd42036115f948d2c962bc0c44328cfa2933e75b32986ec39688abd184c3";
  };

#  src = "/home/auntieneo/code/asterisk/git";
#  configureScript = "true";  # Don't run ./configure for this local build
#  buildPhase = "true";

  coreSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-core-sounds-en-gsm-1.4.26.tar.gz;
    sha256 = "2300e3ed1d2ded6808a30a6ba71191e7784710613a5431afebbd0162eb4d5d73";
  };

  mohSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-moh-opsound-wav-2.03.tar.gz;
    sha256 = "449fb810d16502c3052fedf02f7e77b36206ac5a145f3dacf4177843a2fcb538";
  };

  buildInputs = [ jansson libxml2 libxslt ncurses openssl sqlite utillinux ];

  patches = [
#    ./disable-create-vardirs.patch

    # Disable downloading of audio files (we will fetch them
    # ourselves if needed).
    ./disable-download.patch

    # We want the Makefile to install the /var directory structure
    # under ${out}/var but we also want to use /var at runtime.
    # This patch changes the runtime behavior to look for state
    # directories in /var rather than ${out}/var.
    ./runtime-vardirs.patch
  ];

   preConfigure = ''
     ln -s ${coreSounds} sounds/asterisk-core-sounds-en-gsm-1.4.26.tar.gz
     ln -s ${mohSounds} sounds/asterisk-moh-opsound-wav-2.03.tar.gz
   '';

#  configureFlags = "--with-sounds-cache=asterisk-${version}/sounds/ --localstatedir=/var";
  configureFlags = "--with-sounds-cache=asterisk-${version}/sounds/";

  meta = {
    description = "Software implementation of a telephone private branch exchange (PBX)";
    homepage = http://www.asterisk.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}