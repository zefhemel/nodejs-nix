# This file defines a function that takes a single optional argument 'pkgs'
# If pkgs is not set, it defaults to importing the nixpkgs found in NIX_PATH
{ pkgs ? import <nixpkgs> {} }:
let
   # Convenience alias for the standard environment
   stdenv = pkgs.stdenv;
in rec {
  # Defines our node.js package
  nodejs = stdenv.mkDerivation {
    name = "nodejs-0.10.7";
    # Where to download sources from
    src = pkgs.fetchurl {
      url = http://nodejs.org/dist/v0.10.7/node-v0.10.7.tar.gz;
      sha256 = "1q15siga6b3rxgrmy42310cdya1zcc2dpsrchidzl396yl8x5l92";
    };
    # Dependencies for building node.js (Python and utillinux on Linux, just Python on Mac)
    buildInputs = [ pkgs.python ] ++ stdenv.lib.optional stdenv.isLinux pkgs.utillinux;
    # Hack to make it build on Mac
    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''export PATH=/usr/bin:/usr/sbin:$PATH'';
  };
  # Defines our application package
  app = stdenv.mkDerivation {
    name = "application";
    # The source code is stored in our 'app' directory
    src = ./app;
    # Our package depends on the nodejs package defined above
    buildInputs = [ nodejs ];
    # This is useful for using this package with --run-env: the PORT environment variable
    PORT = "8888";
    # Our application has no ./configure script nor Makefile, installing simply involves
    # copying files from the source directory (set as cwd) to the designated output directory ($out).
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
}
