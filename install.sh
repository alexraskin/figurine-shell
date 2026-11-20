#!/bin/bash

set -e

# Wrapped in main so a truncated `curl | bash` download never runs partially.
main() {

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi


VERSION="v2.1.1"

case "$(uname -m)" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    armv7*|armv8l) ARCH="arm" ;; # upstream arm build is GOARM=7; armv6 (Pi Zero/1) unsupported
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

BASE_URL="https://github.com/arsham/figurine/releases/download/$VERSION"
TARBALL="figurine_linux_${ARCH}_${VERSION}.tar.gz"
URL="$BASE_URL/$TARBALL"
FIGURINE_SCRIPT="/etc/profile.d/figurine.sh"

if command -v curl &> /dev/null; then
    fetch() { curl -fsSLO "$1"; }
elif command -v wget &> /dev/null; then
    fetch() { wget -q "$1"; }
else
    echo "This script requires 'curl' or 'wget' to run." >&2
    exit 1
fi

if ! command -v tar &> /dev/null; then
    echo "This script requires 'tar' to run." >&2
    exit 1
fi

TEMP_DIR=$(mktemp -d) || exit 1
trap 'rm -rf -- "$TEMP_DIR"' EXIT

cd "$TEMP_DIR" || exit 1

fetch "$URL"
fetch "$BASE_URL/CHECKSUM"
grep " $TARBALL\$" CHECKSUM | sha256sum -c - || { echo "Checksum verification failed." >&2; exit 1; }
tar -xvf "$TARBALL"

if [ -d "deploy" ]; then
    # install (not mv) so the binary is root-owned; tarball files are uid 1000
    install -D -o root -g root -m 0755 deploy/figurine /usr/local/bin/figurine || { echo "Failed to install figurine to /usr/local/bin/"; exit 1; }
else
    echo "The expected directory structure is not present." >&2
    exit 1
fi

cat > "$FIGURINE_SCRIPT" <<'EOF'
# Figurine greeting script
case $- in *i*) ;; *) return ;; esac
echo ""
/usr/local/bin/figurine -f "3d.flf" "$(hostname)"
echo ""
EOF


echo "Installation completed successfully."
}

main "$@"
