# Kali Linux Whiptail & QTerminal Pure RGB Theme (`kali-lk-gd`)

[![Platform](https://img.shields.io/badge/Platform-Kali%20Linux%20%2F%20Debian-blue?logo=kalilinux)](https://www.kali.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![Terminal](https://img.shields.io/badge/Terminal-QTerminal%20(Qt5%2FQt6)-darkgreen)](https://github.com/lxqt/qterminal)
[![Theme](https://img.shields.io/badge/Palette-Pure%20RGB-red)](https://github.com)

A system-wide configuration script for Kali Linux that enforces a high-contrast, pure RGB aesthetic across Whiptail (Newt) TUI dialogs and QTerminal emulator sessions. 

It replaces standard muted blues, pastel terminal tones, and distracting window transparencies with pitch-black backgrounds (`#000000`), vivid saturated primary colors (pure green, red, blue, cyan, yellow), and uniform contrast optimized for CLI tools, installers, and penetration testing workflows.

---

## Features

- **System-Wide Whiptail / Newt Theming**: Deploys a customized palette (`/etc/newt/palette.rgb`) mapped to `update-alternatives`, `/etc/environment`, and `/etc/profile.d/newt_rgb.sh` for global persistence across logins and subshells.
- **Pure RGB Terminal Palette**: Generates a custom color scheme (`PureRGB.colorscheme`) utilizing strict 8-bit RGB bounds (`rgb(0,0,0)`, `rgb(255,0,0)`, `rgb(0,255,0)`, `rgb(0,0,255)`, etc.).
- **Zero Transparency / Max Contrast**: Automatically eliminates window and terminal background transparency (`TerminalTransparency=0`, `ApplicationTransparency=0`) to ensure razor-sharp text readability.
- **Multi-Version Qt Compatibility**: Supports both Qt5 and Qt6 color scheme paths (`/usr/share/qtermwidget5/color-schemes` and `/usr/share/qtermwidget6/color-schemes`).
- **Universal User Profile Provisioning**: Automatically discovers and applies configuration directly to `/root` and all user directories in `/home/*`, preserving individual user file ownership.
- **Idempotent Deployment**: Safe to execute repeatedly without duplicating configuration entries or corrupting files.

---

## Before vs. After Comparison

### Visual Comparison

| Before (Default Kali Linux) | After (Pure RGB Theme) |
| :---: | :---: |
| ![Default Kali Linux Whiptail & QTerminal](./before.png) | ![Pure RGB Theme Whiptail & QTerminal](./after.png) |

### Technical Differences

| Component / Feature | Default Kali Linux | Pure RGB Theme (`kali-lk-gd`) |
| :--- | :--- | :--- |
| **Whiptail Background** | Classic blue / dull gray background | Pitch black (`black`) |
| **Whiptail Windows & Borders** | Blue background with white/cyan borders | Pitch black window with bright green borders (`brightgreen,black`) |
| **Whiptail Titles & Highlights** | Low-contrast white or cyan title bars | High-visibility bright red title (`brightred,black`) |
| **Whiptail Buttons** | Muted gray/cyan buttons | High-contrast black on bright red, active state inverted black on bright green |
| **Whiptail Progress Bars (Gauges)** | Low-contrast blue/gray fill | Vivid bright red fill (`brightred,brightred`) on bright blue track |
| **QTerminal Background** | Dark charcoal / navy blue with semi-transparency | Pure solid black (`0,0,0`) with `0%` opacity / transparency |
| **QTerminal Foreground** | Soft muted white/gray | Vibrant pure green (`0,255,0`) |
| **ANSI Color Values** | Desaturated / pastel palette | True mathematical RGB channels (e.g., Red `255,0,0`, Green `0,255,0`, Blue `0,0,255`) |
| **User Persistence** | Often per-user or session-dependent | System-wide via `/etc/environment`, `/etc/profile.d/`, and all `/home/*` directories |

---

## Installation & Script Usage

### Prerequisites
- Kali Linux (or Debian-based distribution)
- Root/sudo access
- QTerminal and Whiptail (pre-installed by default on Kali Linux)

### Quick Run

Clone the repository and run the setup script with root privileges:

```bash
git clone https://github.com/<your-username>/kali-lk-gd.git
cd kali-lk-gd
sudo bash kali-lk-gd.sh
```

### Complete Script (`kali-lk-gd.sh`)

If you want to create or inspect the script manually:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "[-] Run as root: sudo bash $0"
   exit 1
fi

# 1. Configure Newt / Whiptail palette
mkdir -p /etc/newt

cat << 'EOF' > /etc/newt/palette.rgb
root=brightgreen,black
border=brightgreen,black
window=brightgreen,black
shadow=black,black
title=brightred,black
button=black,brightred
actbutton=black,brightgreen
checkbox=brightgreen,black
actcheckbox=brightgreen,black
entry=brightgreen,black
label=brightgreen,black
listbox=brightgreen,black
actlistbox=black,brightgreen
textbox=brightgreen,black
acttextbox=brightgreen,black
helpline=brightcyan,black
roottext=brightcyan,black
emptyscale=brightblue,black
fullscale=brightred,brightred
disentry=black,black
compactbutton=brightgreen,black
actsellistbox=brightgreen,black
sellistbox=brightgreen,black
EOF

update-alternatives --install /etc/newt/palette newt-palette /etc/newt/palette.rgb 100
update-alternatives --set newt-palette /etc/newt/palette.rgb

if ! grep -q "^NEWT_COLORS_FILE=" /etc/environment 2>/dev/null; then
    echo 'NEWT_COLORS_FILE=/etc/newt/palette.rgb' >> /etc/environment
else
    sed -i 's|^NEWT_COLORS_FILE=.*|NEWT_COLORS_FILE=/etc/newt/palette.rgb|' /etc/environment
fi

cat << 'EOF' > /etc/profile.d/newt_rgb.sh
export NEWT_COLORS_FILE=/etc/newt/palette.rgb
EOF
chmod +x /etc/profile.d/newt_rgb.sh

# 2. Deploy QTerminal PureRGB color scheme (Qt5 and Qt6)
for dir in /usr/share/qtermwidget5/color-schemes /usr/share/qtermwidget6/color-schemes; do
    mkdir -p "$dir"
    cat << 'EOF' > "$dir/PureRGB.colorscheme"
[Background]
Color=0,0,0

[BackgroundIntense]
Color=0,0,0

[Foreground]
Color=0,255,0

[ForegroundIntense]
Color=0,255,0
Bold=true

[Color0]
Color=0,0,0

[Color0Intense]
Color=0,0,0

[Color1]
Color=255,0,0

[Color1Intense]
Color=255,0,0
Bold=true

[Color2]
Color=0,255,0

[Color2Intense]
Color=0,255,0
Bold=true

[Color3]
Color=255,255,0

[Color3Intense]
Color=255,255,0
Bold=true

[Color4]
Color=0,0,255

[Color4Intense]
Color=0,0,255
Bold=true

[Color5]
Color=255,0,255

[Color5Intense]
Color=255,0,255
Bold=true

[Color6]
Color=0,255,255

[Color6Intense]
Color=0,255,255
Bold=true

[Color7]
Color=255,255,255

[Color7Intense]
Color=255,255,255
Bold=true

[General]
Description=Pure RGB
Opacity=1
EOF
done

# 3. Apply settings to root and all user profiles
TARGET_HOMES=("/root")
for d in /home/*; do
    [[ -d "$d" ]] && TARGET_HOMES+=("$d")
done

for USER_HOME in "${TARGET_HOMES[@]}"; do
    u=$(stat -c '%U' "$USER_HOME")
    g=$(stat -c '%G' "$USER_HOME")
    CONF_DIR="$USER_HOME/.config/qterminal.org"
    INI_FILE="$CONF_DIR/qterminal.ini"

    mkdir -p "$CONF_DIR"
    if [[ -f "$INI_FILE" ]]; then
        sed -i 's/^colorScheme=.*/colorScheme=PureRGB/' "$INI_FILE"
        sed -i 's/^TerminalTransparency=.*/TerminalTransparency=0/' "$INI_FILE"
        sed -i 's/^ApplicationTransparency=.*/ApplicationTransparency=0/' "$INI_FILE"
        if ! grep -q "^colorScheme=" "$INI_FILE"; then
            sed -i '/^\[General\]/a colorScheme=PureRGB\nTerminalTransparency=0\nApplicationTransparency=0' "$INI_FILE"
        fi
    else
        cat << 'EOF' > "$INI_FILE"
[General]
colorScheme=PureRGB
TerminalTransparency=0
ApplicationTransparency=0
EOF
    fi
    chown -R "$u:$g" "$CONF_DIR"
done

echo "[+] Done. Close ALL QTerminal windows and open a new one."
```

---

## Manual Verification

After running the script, restart your terminal or open a new QTerminal window. Run the following commands to verify the Pure RGB theme across your environment.

### 1. Whiptail Dialog Verification

Test the TUI palette across standard message boxes, prompts, menus, and progress meters:

```bash
# Message Box Test
whiptail --title "Pure RGB Theme" --msgbox "Whiptail dialog theme successfully verified." 10 50

# Yes/No Dialog Test
whiptail --title "Confirm Selection" --yesno "Do you like the Pure RGB theme?" 10 50

# Gauge / Progress Bar Test
for i in {1..100}; do echo $i; sleep 0.01; done | whiptail --title "RGB Gauge Test" --gauge "Testing progress meter..." 8 50 0

# Menu Box Test
whiptail --title "Menu Test" --menu "Choose an option:" 14 50 4 \
  1 "Option One" \
  2 "Option Two" \
  3 "Option Three"
```

### 2. Environment & Alternatives Check

Confirm that the Newt color palette is properly registered and exported:

```bash
# Verify environment variable
echo "$NEWT_COLORS_FILE"
# Output should return: /etc/newt/palette.rgb

# Verify Debian update-alternatives selection
update-alternatives --display newt-palette
```

### 3. QTerminal Configuration Check

Verify that the QTerminal configuration file has been updated with the `PureRGB` color scheme and zero transparency:

```bash
grep -E '(colorScheme|TerminalTransparency|ApplicationTransparency)' ~/.config/qterminal.org/qterminal.ini
```

Expected output:
```ini
colorScheme=PureRGB
TerminalTransparency=0
ApplicationTransparency=0
```

---

## License

This project is licensed under the [MIT License](LICENSE).

