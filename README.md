
# UbuntuToHack 🧠💻

<img width="1024" height="1024" alt="ChatGPT Image 16 jul 2025, 22_29_52" src="https://github.com/user-attachments/assets/b4915b54-8615-46e5-b265-96a47b3c10b6" />


Convierte tu sistema Ubuntu en una estación de hacking ético profesional con un solo script. Incluye herramientas, HUD estilo hacker, terminal avanzada, entorno gráfico personalizado, fuentes, diccionarios y automatización total.

## 🛠 ¿Qué instala?

- 🧰 Herramientas de pentesting: `nmap`, `sqlmap`, `hydra`, `john`, `hashcat`, `aircrack-ng`, `wfuzz`, `gobuster`, `reaver`, `nikto`, etc.
- 🧠 HUD hacker: `conky` personalizado con CPU, RAM, red, procesos, fecha/hora.
- 💻 Terminal avanzada: `zsh`, `Oh-My-Zsh`, `powerlevel10k`, `neofetch`.
- 🌐 Herramientas gráficas: `Wireshark`, `Zenmap`, `Burp Suite`, `Maltego CE`.
- 📦 Python y pipx: entornos virtuales + instalación segura de librerías y herramientas.
- 📁 Diccionarios: `SecLists`, `rockyou`, `PEASS`, `LinEnum`, etc.
- 🎨 Personalización GNOME: modo oscuro, wallpaper hacker, fuentes Nerd Font.

---

## 📦 Requisitos

- Ubuntu 24.04 Desktop
- Usuario con permisos `sudo`
- Conexión a internet

---

## 🚀 Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/panchoxgrande/ubuntutohack.git
cd ubuntutohack
````

2. Da permisos de ejecución al script:

```bash
chmod +x setup_ubuntu_hacker.sh
```

3. Ejecuta el script como **usuario normal** (¡no como root!):

```bash
./setup_ubuntu_hacker.sh
```

---

## ⚠️ Recomendación importante

> 🔁 **Corre el script 2 veces**
> En algunos sistemas, ciertas configuraciones visuales y terminales (fuentes, Conky, GNOME settings) pueden requerir una segunda ejecución del script para aplicarse correctamente.

---

## 📂 Resultados

* Herramientas instaladas en el sistema y accesibles por terminal.
* HUD en escritorio (Conky) cargado al inicio.
* Terminal Tilix o GNOME personalizada.
* Wallpaper estilo hacker aplicado automáticamente.
* Hack Nerd Font configurada como fuente por defecto.

---

## 🧪 Extras

* Entorno virtual para librerías Python en `~/venvs/hacktools`
* Puedes activarlo con:

```bash
source ~/venvs/hacktools/bin/activate
```

* Para Conky, si tu interfaz no es `wlo1`, edita el archivo `~/.conky/conkyrc` y reemplázalo por `enp3s0`, `eth0` o la que corresponda (`ip a`).

---

## 📷 Capturas (opcional)

> Pronto.......

---

## 📜 Licencia

MIT — Libre para usar, modificar y compartir.

---

## ✍ Autor

**PanchoxGrande**
🔗 [github.com/panchoxgrande](https://github.com/panchoxgrande)

```





