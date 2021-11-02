#!/bin/bash
set -euo pipefail

ayli="$(dirname "$(realpath "$0")")"/ayli.sh
chmod +x "$ayli"
ln -fs "$ayli" "$HOME"/.local/bin/ayli
