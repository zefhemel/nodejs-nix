{ pkgs ? import <nixpkgs> {} }:
let
   stdenv = pkgs.stdenv;
in rec {
  nodejs = stdenv.mkDerivation rec {
    version = "0.10.7";
    name = "nodejs-${version}";
    src = pkgs.fetchurl {
      url = http://nodejs.org/dist/v0.10.7/node-v0.10.7.tar.gz;
      sha256 = "1q15siga6b3rxgrmy42310cdya1zcc2dpsrchidzl396yl8x5l92";
    };
    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''export PATH=/usr/bin:/usr/sbin:$PATH'';
    buildInputs = [ pkgs.python ] ++ stdenv.lib.optional stdenv.isLinux pkgs.utillinux;
  };
  app = stdenv.mkDerivation {
    name = "application";
    src = ./app;
    buildInputs = [ nodejs ];
    PORT = "8888";
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
}
