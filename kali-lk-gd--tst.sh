cat << 'SCRIPT_EOF' > kali-lk-gd.sh
#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "[-] Run as root: sudo bash $0"
   exit 1
fi

# 1. Create /etc/newt directory and configure newt/whiptail palette
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
actcheckbox=black,brightgreen
entry=brightgreen,black
label=brightgreen,black
listbox=brightgreen,black
actlistbox=black,brightgreen
textbox=brightgreen,black
acttextbox=black,brightgreen
helpline=brightcyan,black
roottext=brightcyan,black
emptyscale=brightblue,black
fullscale=brightred,brightred
disentry=black,black
compactbutton=brightgreen,black
actsellistbox=black,brightgreen
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

# 2. Write strict 0/255 RGB Color Scheme for QTerminal (Qt5 & Qt6)
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

# 3. Apply to QTerminal config for root and all users in /home
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

echo "[+] Applied. Close ALL QTerminal windows and open a new one, then test with:"
echo 'NEWT_COLORS_FILE=/etc/newt/palette.rgb whiptail --backtitle "Package configuration" --title "Installing packages" --gauge "Unpacking metasploit-framework (amd64)" 8 74 24 <<< "24"'
SCRIPT_EOF
chmod +x kali-lk-gd.sh && ./kali-lk-gd.sh
