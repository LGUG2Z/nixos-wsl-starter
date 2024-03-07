{pkgs ? import <nixpkgs>}: let
  pname = "win32yank";
  version = "0.1.1";
  bin = "win32yank.exe";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchzip {
      url = "https://github.com/equalsraf/win32yank/releases/download/v${version}/win32yank-x64.zip";
      sha256 = "sha256-4ivE1cYZhYs4ibx5oiYMOhbse9bdOomk7RjgdVl5lD0=";
      stripRoot = false;
    };

    inherit bin;

    installPhase = ''
      mkdir -p $out/bin
      cp $bin $out/bin
      chmod +x $out/bin/*
    '';
  }
