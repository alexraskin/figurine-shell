#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 '<figurine_text>'" >&2
  exit 1
fi

FIGURINE_TEXT="$1"


URL="https://github.com/arsham/figurine/releases/download/v1.3.0/figurine_linux_amd64_v1.3.0.tar.gz"
FIGURINE_SCRIPT="/etc/profile.d/figurine.sh"

if ! command -v wget &> /dev/null || ! command -v tar &> /dev/null; then
    echo "This script requires 'wget' and 'tar' to run." >&2
    exit 1
fi

TEMP_DIR=$(mktemp -d) || exit 1
trap 'rm -rf -- "$TEMP_DIR"' EXIT

cd "$TEMP_DIR" || exit 1

wget "$URL" && tar -xvf "$(basename "$URL")"

if [ -d "deploy" ]; then
    mv deploy/figurine /usr/local/bin/ || { echo "Failed to move figurine to /usr/local/bin/"; exit 1; }
else
    echo "The expected directory structure is not present." >&2
    exit 1
fi

cat > "$FIGURINE_SCRIPT" <<EOF
#!/bin/bash
# Figurine greeting script
echo ""
/usr/local/bin/figurine -f "3d.flf" "$FIGURINE_TEXT"
echo ""
EOF


echo "Installation completed successfully."
