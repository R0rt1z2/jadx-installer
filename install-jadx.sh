#!/bin/bash

set -e

GITHUB_API="https://api.github.com/repos/skylot/jadx/releases/latest"
INSTALL_DIR="/opt/jadx"
BIN_DIR="/usr/local/bin"
GDK_SCALE_VALUE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --scale)
            GDK_SCALE_VALUE="$2"
            shift 2
            ;;
        *)
            echo "Usage: $0 [--scale VALUE]"
            echo "  --scale VALUE    Set GDK_SCALE value for GUI scaling (e.g., 2 for 4K displays)"
            exit 1
            ;;
    esac
done

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Fetching latest JADX release information..."
RELEASE_DATA=$(curl -s "$GITHUB_API")
JADX_VERSION=$(echo "$RELEASE_DATA" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
JADX_URL=$(echo "$RELEASE_DATA" | grep '"browser_download_url":' | grep "jadx-.*\.zip" | grep -v "gui" | head -1 | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$JADX_VERSION" ] || [ -z "$JADX_URL" ]; then
    echo "Failed to fetch release information"
    exit 1
fi

echo "Installing JADX v${JADX_VERSION}..."

cd /tmp
wget -O "jadx-${JADX_VERSION}.zip" "$JADX_URL"

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -q "jadx-${JADX_VERSION}.zip" -d "$INSTALL_DIR"
chmod +x "${INSTALL_DIR}/bin/jadx"
chmod +x "${INSTALL_DIR}/bin/jadx-gui"

cat > "${BIN_DIR}/jadx" << 'EOF'
#!/bin/bash
exec /opt/jadx/bin/jadx "$@"
EOF

if [ -n "$GDK_SCALE_VALUE" ]; then
    cat > "${BIN_DIR}/jadx-gui" << EOF
#!/bin/bash
export GDK_SCALE=${GDK_SCALE_VALUE}
nohup /opt/jadx/bin/jadx-gui "\$@" >/dev/null 2>&1 &
EOF
else
    cat > "${BIN_DIR}/jadx-gui" << 'EOF'
#!/bin/bash
nohup /opt/jadx/bin/jadx-gui "$@" >/dev/null 2>&1 &
EOF
fi

chmod +x "${BIN_DIR}/jadx"
chmod +x "${BIN_DIR}/jadx-gui"

wget -O /usr/share/icons/jadx.svg "https://raw.githubusercontent.com/R0rt1z2/jadx-installer/main/jadxlogo.svg"

cat > /usr/share/applications/jadx.desktop << 'EOF'
[Desktop Entry]
Name=JADX
Comment=Dex to Java decompiler
Exec=/usr/local/bin/jadx-gui
Terminal=false
Type=Application
Categories=Development;
Icon=jadx
EOF

rm "/tmp/jadx-${JADX_VERSION}.zip"

echo "JADX ${JADX_VERSION} installed successfully"
echo "Command line: jadx"
echo "GUI: jadx-gui"
