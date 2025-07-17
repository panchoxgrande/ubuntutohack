#!/bin/bash
# setup_ubuntu_hacker.sh - Script completo para preparar Ubuntu 24.04 como entorno de hacking ético

set -e

echo "🔄 Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Instalando herramientas esenciales..."
sudo apt install -y build-essential git curl wget python3 python3-pip zsh tilix gnome-tweaks conky-all neofetch net-tools \
nmap netcat-openbsd sqlmap hydra john hashcat aircrack-ng reaver nikto gobuster wfuzz binwalk sleuthkit autopsy whois dnsutils traceroute

echo "🧪 Instalando herramientas gráficas de pentesting..."
sudo apt install -y wireshark zenmap

#echo "🔍 Instalando Burp Suite Community Edition..."
#sudo snap install burpsuite

echo "🌐 Instalando Maltego CE..."
wget -O ~/Descargas/maltego.deb https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.6.0.deb
sudo apt install -y ./Descargas/maltego.deb || sudo dpkg -i ~/Descargas/maltego.deb; sudo apt --fix-broken install -y

echo "🐍 Instalando librerías Python útiles..."
pip3 install --upgrade pip
pip3 install pwntools scapy requests

echo "📂 Descargando diccionarios y herramientas desde GitHub..."
mkdir -p ~/Tools ~/wordlists && cd ~/wordlists
git clone --depth=1 https://github.com/danielmiessler/SecLists.git
cd ~/Tools
git clone https://github.com/carlospolop/PEASS-ng.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/projectdiscovery/nuclei.git && cd nuclei && make install

echo "🎨 Personalizando entorno gráfico GNOME..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 11'

echo "🖼 Descargando wallpaper hacker..."
mkdir -p ~/Imágenes/wallpapers
wget -O ~/Imágenes/wallpapers/hacker_wallpaper.png https://wallpaperaccess.com/full/1814373.jpg
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Imágenes/wallpapers/hacker_wallpaper.png"

echo "💻 Configurando terminal avanzada con Zsh y Powerlevel10k..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
grep -qxF 'neofetch' ~/.zshrc || echo "neofetch" >> ~/.zshrc

echo "🧠 Configurando HUD Conky estilo hacker..."
mkdir -p ~/.conky
cat > ~/.conky/conkyrc << 'EOF'
conky.config = {
  alignment = 'top_right', background = true, update_interval = 1,
  double_buffer = true, own_window = true, own_window_type = 'desktop',
  own_window_transparent = true, use_xft = true,
  font = 'Fira Code:size=10', default_color = '00FF00',
};
conky.text = [[
${time %A, %d %B %Y} ${alignr}${time %H:%M:%S}
Uptime: ${uptime}
CPU: ${cpu}% ${cpubar}
RAM: $mem/$memmax ${membar}
Root: ${fs_used /}/${fs_size /} ${fs_bar /}
Net: ↓${downspeed wlo1} ↑${upspeed wlo1}
Processes: $processes  Running: $running_processes
]];
EOF

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/conky.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=conky -c ~/.conky/conkyrc
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky System Monitor
EOF

echo "📌 Estableciendo Tilix como terminal por defecto..."
gsettings set org.gnome.desktop.default-applications.terminal exec 'tilix'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-x'

echo "✅ Instalación finalizada. Reinicia tu sesión para ver todos los cambios."
