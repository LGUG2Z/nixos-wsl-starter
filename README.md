# nixos-wsl-starter

This repository is intended to be a sane, batteries-included starter template
for running a LunarVim-powered NixOS development environment on WSL.

If you don't want to dig into NixOS too much right now, the only file you need
to concern yourself with is [home.nix](home.nix). This is where you can add and
remove binaries to your global `$PATH`.

Go to [https://search.nixos.org](https://search.nixos.org/packages) to find the
correct package names, though usually they will be what you expect them to be
in other package managers.

`unstable-packages` is for packages that you want to always keep at the latest
released versions, and `stable-packages` is for packages that you want to track
with the current release of NixOS (currently 23.11).

If you want to update the versions of the available `unstable-packages`, run
`nix flake update` to pull the latest version of the Nixpkgs repository and
then apply the changes.

Make sure to look at all the `FIXME` notices in the various files which are
intended to direct you to places where you may want to make configuration
tweaks.

If you found this starter template useful, please consider
[sponsoring](https://github.com/sponsors/LGUG2Z) and [subscribing to my YouTube
channel](https://www.youtube.com/channel/UCeai3-do-9O4MNy9_xjO6mg?sub_confirmation=1).

## What Is Included

This starter is a lightly-opinionated take on a productive terminal-driven
development environment based on my own preferences. However, it is trivial to
customize to your liking both by removing and adding tools that you prefer.

* The default editor is `lvim`
* `win32yank` is used to ensure perfect bi-directional copying and pasting to
  and from Windows GUI applications and LunarVim running in WSL
* The default shell is `zsh`
* Native `docker` (ie. Linux, not Windows) is enabled by default
* The prompt is [Starship](https://starship.rs/)
* [`fzf`](https://github.com/junegunn/fzf),
  [`lsd`](https://github.com/lsd-rs/lsd),
  [`zoxide`](https://github.com/ajeetdsouza/zoxide), and
  [`broot`](https://github.com/Canop/broot) are integrated into `zsh` by
  default
    * These can all be disabled easily by setting `enable = false` in
      [home.nix](home.nix), or just removing the lines all together
* [`direnv`](https://github.com/direnv/direnv) is integrated into `zsh` by
  default
* `git` config is generated in [home.nix](home.nix) with options provided to
  enable private HTTPS clones with secret tokens
* `zsh` config is generated in [home.nix](home.nix) and includes git aliases,
  useful WSL aliases, and
  [sensible`$WORDCHARS`](https://lgug2z.com/articles/sensible-wordchars-for-most-developers/)

## Quickstart

[![Watch the walkthrough video](https://img.youtube.com/vi/UmRXXYxq8k4/hqdefault.jpg)](https://www.youtube.com/watch?v=UmRXXYxq8k4)

* Get the [latest NixOS-WSL
  installer](https://github.com/nix-community/NixOS-WSL)
* Install it (tweak the command to your desired paths):
```powershell
wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2

```

* Enter the distro:
```powershell
wsl -d NixOS
```

* Set up a channel:
```bash
sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
sudo nix-channel --update
```

* Get a copy of this repo (you'll probably want to fork it eventually):
```bash
nix-shell -p git neovim
git clone https://github.com/LGUG2Z/nixos-wsl-starter.git /tmp/configuration
cd /tmp/configuration
```

* Change the username to your desired username in `flake.nix` with `nvim` (or whichever editor you prefer)
* Apply the configuration
```bash
sudo nixos-rebuild switch --flake /tmp/configuration
```

* Restart and reconnect to the current WSL shell
```bash
wsl -t NixOS
wsl -d NixOS
```

* `cd ~` and then `pwd` should now show `/home/<YOUR_USERNAME>`
* Move the configuration to your new home directory 
```bash
mv /tmp/configuration ~/configuration
```

* Go through all the `FIXME:` notices in `~/configuration` and make changes
  wherever you want
* Apply the configuration
```bash
sudo nixos-rebuild switch --flake ~/configuration
```

Note: If developing in Rust, you'll still be managing your toolchains and components like `rust-analyzer` with `rustup`!

## Project Layout

In order to keep the template as approachable as possible for new NixOS users,
this project uses a flat layout without any nesting or modularization.

* `flake.nix` is where dependencies are specified
    * `nixpkgs` is the current release of NixOS
    * `nixpkgs-unstable` is the current trunk branch of NixOS (ie. all the
      latest packages)
    * `home-manager` is used to manage everything related to your home
      directory (dotfiles etc.)
    * `nur` is the community-maintained [Nix User
      Repositories](https://nur.nix-community.org/) for packages that may not
      be available in the NixOS repository
    * `nixos-wsl` exposes important WSL-specific configuration options
    * `nix-index-database` tells you how to install a package when you run a
      command which requires a binary not in the `$PATH`
* `wsl.nix` is where the VM is configured
    * The hostname is set here
    * The default shell is set here
    * User groups are set here
    * WSL configuration options are set here
    * NixOS options are set here
* `home.nix` is where packages, dotfiles, terminal tools, environment variables
  and aliases are configured
