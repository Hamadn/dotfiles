#!/usr/bin/env bash
set -euo pipefail

echo "Installing fonts..."
FONT_DIR="$HOME/.local/share/fonts/petiglyph"
mkdir -p "$FONT_DIR"
cp fonts/package.ttf "$FONT_DIR/"
fc-cache -fv

echo "Stowing packages..."
for pkg in polybar fastfetch i3 input-remapper mpv ncmpcpp nvim qutebrowser tmux wezterm zsh; do
  if [ -d "$pkg" ]; then
    stow "$pkg"
    echo "  stowed $pkg"
  fi
done

echo "Done. Restart polybar to pick up the new font."
