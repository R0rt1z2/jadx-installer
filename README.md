# JADX Installer

Shell script to install [JADX](https://github.com/skylot/jadx) automatically. Downloads latest release, sets up launchers, creates desktop entry.

## Why?

Automates the boring stuff. Fetches latest version, handles extraction, creates proper launchers, adds desktop integration.

## Setup

Download and run:
```bash
curl -s https://raw.githubusercontent.com/R0rt1z2/jadx-installer/refs/heads/main/install-jadx.sh | sudo bash
```

For 4K displays:
```bash
curl -s https://raw.githubusercontent.com/R0rt1z2/jadx-installer/refs/heads/main/install-jadx.sh | sudo bash -s -- --scale 2
```

> [!NOTE]
> You might want to specify different scaling values like `--scale 1.5` for QHD displays or adjust based on your preference.

## Usage

**Command line:**
```bash
jadx app.apk
jadx classes.dex
```

**GUI:**
```bash
jadx-gui
```

GUI runs in background so you can close the terminal.

## Requirements

- JDK 11 installed
- Internet connection for download
- Root access for system installation

## Credits

- JADX by [skylot](https://github.com/skylot/jadx) - Apache License 2.0
- Icon by [ethanblake4](https://github.com/ethanblake4)
