#!/bin/bash
set -e

# Update and upgrade
sudo apt update && sudo apt upgrade -y

# Remove unwanted pre-installed applications
sudo snap remove firefox thunderbird
sudo apt purge -y yelp libreoffice* rhythmbox firefox* thunderbird* shotwell gnome-clocks gnome-calculator remmina gnome-calendar gnome-screenshot gnome-text-editor transmission-common transmission-gtk
sudo snap remove snap-store
sudo apt autoremove -y

# Install essential tools
sudo apt install -y curl git dconf-cli xclip vim

# NVM and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
command -v nvm
nvm install node
node -v
npm -v

# pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Docker
sudo apt install -y apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install -y docker-ce docker-compose-plugin

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config
cp ./config/starship.toml ~/.config/starship.toml

# Append custom bash configuration
cat ./config/.bashrc >> ~/.bashrc

# Code
sudo apt-get install -y gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code
mkdir -p ~/.config/Code/User
cp .vscode/settings.json ~/.config/Code/User/settings.json
cp .vscode/keybindings.json ~/.config/Code/User/keybindings.json

# Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Nerd Fonts
mkdir -p ~/.local/share/fonts
curl -fLo ~/.local/share/fonts/DejaVuSansMNerdFont-Regular.ttf https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFont-Regular.ttf

# Terminal
sudo apt install -y picom
dconf load /org/gnome/terminal/ < ./config/terminal.dconf
mkdir -p ~/.config/picom
cp ./config/picom.conf ~/.config/picom/picom.conf

# Rofi
sudo apt install -y rofi papirus-icon-theme
mkdir -p ~/.config/rofi
cp ./rofi/config.rasi ~/.config/rofi/config.rasi

# i3
sudo apt install -y feh i3
cp ./config/wallpaper.png ~/Pictures/wallpaper.png

# Polybar
sudo apt install -y polybar xdotool
sudo cp ./polybar/config.ini /etc/polybar/config.ini

chmod +x ./follow-up.sh

sudo reboot
