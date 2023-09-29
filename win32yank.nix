{pkgs ? import <nixpkgs>}: let
  pname = "win32yank";
  version = "0.0.4";
  bin = "win32yank.exe";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchzip {
      url = "https://github.com/equalsraf/win32yank/releases/download/v${version}/win32yank-x64.zip";
      sha256 = "1jzb2zabx777dpjn8bh94biakzch2ybw9bxs0sbhf67i84xxqi2n";
      stripRoot = false;
    };

    inherit bin;

    installPhase = ''
      mkdir -p $out/bin
      cp $bin $out/bin
      chmod +x $out/bin/*
    '';
  }
