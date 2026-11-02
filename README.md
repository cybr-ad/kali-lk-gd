# Kali Linux Pure RGB Theme (`kali-lk-gd`)

A clean, high-contrast **Pure RGB** theme for Kali Linux Whiptail dialogs and QTerminal.

It replaces default muted blues and translucent terminal windows with a solid pitch-black background and vibrant, high-contrast RGB colors.

---

## 📸 Before & After

| Before (Default Kali) | After (Pure RGB) |
| :---: | :---: |
| ![Before](./before.png) | ![After](./after.png) |

---

## ✨ Features

- **Pitch-Black Background**: Solid black background with 0% transparency for maximum readability.
- **Vibrant RGB Palette**: Crisp neon green text, sharp borders, and bold red highlights.
- **System-Wide Theming**: Applies across all Whiptail dialogs, system menus, and QTerminal.
- **Multi-User Ready**: Automatically configures both `root` and standard user accounts.
- **One-Command Setup**: Simple automated bash script that sets up everything in seconds.

---

## 🔍 Quick Comparison

| Feature | Default Kali | Pure RGB (`kali-lk-gd`) |
| :--- | :--- | :--- |
| **Terminal Background** | Dark gray / semi-transparent | Solid pitch black (`#000000`) |
| **Terminal Text** | Muted white / gray | Bright neon green (`#00FF00`) |
| **Whiptail Dialogs** | Classic blue & gray | Modern black & bright green |
| **Dialog Titles & Buttons** | Soft blue / gray | High-contrast bright red & green |
| **Window Transparency** | Semi-transparent | 100% Opaque (no distractions) |

---

## 🚀 Installation

Open your terminal and run:

```bash
git clone https://github.com/<your-username>/kali-lk-gd.git
cd kali-lk-gd
sudo bash kali-lk-gd.sh
```

> **Tip:** After the script finishes, close all open QTerminal windows and open a new one to see the changes.

---

## 🧪 Test It Out

Test your new Whiptail theme immediately with this simple command:

```bash
whiptail --title "Pure RGB Theme" --msgbox "Theme installed successfully!" 10 50
```

Or test a Yes/No prompt:

```bash
whiptail --title "Theme Test" --yesno "Do you like the new Pure RGB look?" 10 50
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
