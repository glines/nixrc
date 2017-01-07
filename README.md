# nixrc
This is a collection of the configuration files that I use with NixOS, a Linux
distribution inspired by purely functional programming languages.

These configuration files reflect how I use NixOS on a daily basis; as such,
they contain a lot of peculiar code not written for general use. If you
find some of the techniques I use in these files to be useful, feel free
to use them as a template for your own NixOS configuration.

## Organization
My configuration is organized with two goals in mind: First, the configuration
of several computers that I own is unified into this one repository with
minimal duplication of effort. Second, everything necessary to provision a new
machine from scratch is included along with a script to ease initial
installation.

### Machines
The `machines/` directory contains a separate NixOS module for each
computer that I have configured with NixOS. Since each computer is used in
different settings, it is only natural that each of these modules is slightly
different.

### Profiles
A number of different configuration profiles are defined as NixOS modules in
the `profiles/` directory. Each computer can import any number of different
profiles. This minimizes the duplication of effort when two or more computers
are commonly used for the same tasks. For instance, if I commonly use a printer
from either my laptop or my desktop, I can import the `printing.nix` profile on
those computers, while omitting it on my server.

### Dotfiles
I keep various configuration files for userland applications in the `dotfiles/`
directory. This allows me to keep the configuration files that I find
important, such as my VIM or Git configuration files, consistent across
computers.

Note that NixOS does not provide any built-in support for managing userland
dotfiles. I simply create the dotfiles as symbolic links from a startup script.

### install.sh
I use the `install.sh` script to start a new installation from scratch. The
script is not perfect, but it attempts to identify computers I own and use the
appropriate hostname.

### Makefile / update.sh
The `update.sh` script is interesting because whenever 

## License
As this repository does not really constitute a coherent product, I am
releasing everything I have written here to the public domain without warranty
of any kind. Note that some of the code in this repository may have been pulled
from elsewhere; such code is the property of its respective copyright holder.
