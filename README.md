# Getting Started

* Get the [latest NixOS-WSL installer](https://github.com/nix-community/NixOS-WSL/actions/runs/6159516082)
* Install it (tweak the command to your desired paths): `wsl --import NixOS .\NixOS\ .\nixos-wsl-installer.tar.gz --version 2`
* Enter the distro with `wsl -d NixOs`
* Get a copy of this repo
```bash
cd ~
nix-shell -p busybox
curl -L https://github.com/LGUG2Z/nixos-wsl-starter/archive/refs/heads/master.zip | unzip -
mv nixos-wsl-starter-master configuration
```
* Change the username to your desired username in `flake.nix`
* Apply the configuration with `sudo nixos-rebuild switch --impure --flake ~/configuration`
* Disconnect from your current WSL shell and then reconnect again with `wsl -d NixOS`
* `cd` and then `pwd` should now show `/home/<YOUR_USERNAME>`
* Do this bit again because the temporary initial home directory was blown away when we applied our configuration
```bash
cd ~
nix-shell -p busybox
curl -L https://github.com/LGUG2Z/nixos-wsl-starter/archive/refs/heads/master.zip | unzip -
mv nixos-wsl-starter-master configuration
```
* Install LunarVim: `LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)` (select "no" for all dependency prompts)
* Change the username to your desired username in `flake.nix` one last time
* Go through all the `FIXME:` notices in `~/configuration` and make changes wherever you want
* Apply any further changes with `sudo nixos-rebuild switch --impure --flake ~/configuration`
