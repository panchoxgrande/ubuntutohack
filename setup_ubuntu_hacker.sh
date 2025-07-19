#!/bin/bash
# setup_ubuntu_hacker.sh - Script completo para preparar Ubuntu 24.04 como entorno de hacking ético

set -e

echo "🔄 Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Instalando herramientas esenciales..."
sudo apt install -y --no-install-recommends build-essential git curl wget zsh tilix gnome-tweaks conky-all neofetch net-tools \
nmap netcat-openbsd sqlmap hydra john hashcat aircrack-ng reaver nikto gobuster wfuzz binwalk sleuthkit autopsy whois dnsutils traceroute

mkdir -p ~/.local/share/fonts/hack
wget -O Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
unzip -o Hack.zip -d ~/.local/share/fonts/hack
rm Hack.zip
fc-cache -fv

echo "🐚 Instalando Oh-My-Zsh y Powerlevel10k..."
if ! command -v zsh &> /dev/null; then
  sudo apt install -y --no-install-recommends zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "✅ Powerlevel10k ya está clonado. Omitiendo..."
fi
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
chsh -s "$(which zsh)"
grep -qxF 'neofetch' ~/.zshrc || echo "neofetch" >> ~/.zshrc

echo "🐍 Configurando entorno Python seguro en Ubuntu 24.04..."

# Asegurar dependencias del sistema
sudo apt install -y python3-venv python3-pip pipx

# Asegurar que pipx esté en PATH
pipx ensurepath

# Crear entorno virtual dedicado
echo "📦 Creando entorno virtual ~/venvs/hacktools..."
mkdir -p ~/venvs
python3 -m venv ~/venvs/hacktools

# Activar entorno virtual
source ~/venvs/hacktools/bin/activate

# Instalar librerías específicas
pip install --upgrade pip
pip install pwntools scapy requests

# Salir del entorno virtual
deactivate

# Instalar herramientas CLI útiles con pipx (aisladas del sistema)
echo "🛠 Instalando herramientas CLI con pipx..."
pipx install mitmproxy
pipx install httpie
pipx install yq

echo "✅ Python y pipx configurados de forma segura."
echo "ℹ️ Para usar tus herramientas: source ~/venvs/hacktools/bin/activate"

echo "📂 Descargando herramientas desde GitHub..."
mkdir -p ~/Tools ~/wordlists

cd ~/wordlists
if [ ! -d "SecLists" ]; then
  git clone --depth=1 https://github.com/danielmiessler/SecLists.git
else
  echo "✅ SecLists ya está clonado. Omitiendo..."
fi

cd ~/Tools
if [ ! -d "PEASS-ng" ]; then
  git clone https://github.com/carlospolop/PEASS-ng.git
else
  echo "✅ PEASS-ng ya está clonado. Omitiendo..."
fi

if [ ! -d "LinEnum" ]; then
  git clone https://github.com/rebootuser/LinEnum.git
else
  echo "✅ LinEnum ya está clonado. Omitiendo..."
fi

echo "🔧 Instalando Golang (requerido por Nuclei)..."
sudo apt install -y --no-install-recommends golang

if [ ! -d "nuclei" ]; then
  git clone https://github.com/projectdiscovery/nuclei.git
  cd nuclei && make install
else
  echo "✅ Nuclei ya está clonado. Omitiendo instalación..."
fi

echo "🛡️ Instalando Burp Suite Community Edition..."
BURP_URL="https://portswigger.net/burp/releases/download?product=community&version=2024.3.1&type=Linux"
BURP_DEB="$HOME/Descargas/burpsuite_installer.sh"
mkdir -p ~/Descargas
wget -O "$BURP_DEB" "$BURP_URL"
chmod +x "$BURP_DEB"
"$BURP_DEB" -q

echo "🎨 Aplicando tema oscuro y wallpaper..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 11'

WALL_DIR="$PWD/wallpapers"
if [ -d "$WALL_DIR" ]; then
  WALL=$(find "$WALL_DIR" -type f | shuf -n1)
  gsettings set org.gnome.desktop.background picture-uri "file://$WALL"
fi

echo "🧠 Configurando HUD con Conky..."
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
Net: ↓${downspeed etcat-openbsd} ↑${upspeed etcat-openbsd}
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
echo "🔠 Estableciendo Hack Nerd Font como fuente predeterminada..."

# Tilix (automático)
if command -v tilix &> /dev/null; then
    TILIX_PROFILE=$(dconf list /com/gexperts/Tilix/profiles/ | grep '^:' | head -n1 | tr -d '/')
    if [ -n "$TILIX_PROFILE" ]; then
        dconf write /com/gexperts/Tilix/profiles/${TILIX_PROFILE}/use-system-font false
        dconf write /com/gexperts/Tilix/profiles/${TILIX_PROFILE}/font "'Hack Nerd Font Mono 11'"
        echo "✔️ Fuente aplicada a Tilix"
    else
        echo "⚠️ No se pudo detectar perfil de Tilix"
    fi
fi

# GNOME Terminal (opcional)
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID"

if [ -n "$PROFILE_ID" ]; then
    gsettings set $PROFILE_PATH use-system-font false
    gsettings set $PROFILE_PATH font 'Hack Nerd Font Mono 11'
    echo "✔️ Fuente aplicada a GNOME Terminal"
else
    echo "⚠️ No se pudo aplicar fuente a GNOME Terminal"
fi
# 📷 Estableciendo fondo de pantalla personalizado
mkdir -p ~/Imágenes/wallpapers
cp 1000090902.png ~/Imágenes/wallpapers/hacker_fondo.png

gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Imágenes/wallpapers/hacker_fondo.png"

echo "✅ Instalación finalizada. Reinicia tu sesión para aplicar los cambios."
