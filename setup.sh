#!/usr/bin/env bash
set -euo pipefail

echo "Installing packages..."
sudo pacman -S --needed - < pkglist-repo.txt
yay -S --needed - < pkglist-aur.txt

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

echo "Installing libvirt hooks..."
sudo mkdir -p /etc/libvirt/hooks/qemu.d/win11/{prepare/begin,release/end}
sudo cp libvirt-hooks/qemu /etc/libvirt/hooks/
sudo cp libvirt-hooks/kvm.conf /etc/libvirt/hooks/
sudo cp libvirt-hooks/qemu.d/win11/prepare/begin/start.sh /etc/libvirt/hooks/qemu.d/win11/prepare/begin/
sudo cp libvirt-hooks/qemu.d/win11/release/end/revert.sh /etc/libvirt/hooks/qemu.d/win11/release/end/
sudo chmod +x /etc/libvirt/hooks/qemu \
  /etc/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh \
  /etc/libvirt/hooks/qemu.d/win11/release/end/revert.sh

echo "Done. Restart polybar to pick up the new font."
