#!/usr/bin/env bash
set -euo pipefail

echo "Installing packages..."
sudo pacman -S --needed - < pkglist-repo.txt
yay -S --needed - < pkglist-aur.txt

echo "Installing fzf-git.sh..."
[ -d "$HOME/fzf-git.sh" ] || git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/fzf-git.sh"

echo "Installing oh-my-zsh..."
[ -d "$HOME/.oh-my-zsh" ] || git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

echo "Installing oh-my-zsh custom plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || git clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

echo "Installing fonts..."
FONT_DIR="$HOME/.local/share/fonts/petiglyph"
mkdir -p "$FONT_DIR"
cp fonts/package.ttf "$FONT_DIR/"
fc-cache -fv

echo "Stowing packages..."
for pkg in polybar fastfetch i3 mpv ncmpcpp nvim qutebrowser tmux wezterm zsh; do
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
echo ""
echo "=== Post-install manual steps ==="
echo ""
echo "1. Kernel cmdline (GPU passthrough):"
echo "   Edit /etc/default/grub, add to GRUB_CMDLINE_LINUX_DEFAULT:"
echo "     intel_iommu=on iommu=pt ibt=off nvidia_drm.modeset=1"
echo "   Then: sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo ""
echo "2. Enable libvirt system services:"
echo "   sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket"
echo ""
echo "3. Start default network + storage:"
echo "   sudo virsh net-start default && sudo virsh net-autostart default"
echo "   sudo virsh pool-start default && sudo virsh pool-autostart default"
echo ""
echo "4. Restore VM files + define VM:"
echo "   sudo cp libvirt-hooks/{patch.rom,SSDT1.dat} /home/\$USER/"
echo "   # Edit win11.xml: fix ISO and disk paths"
echo "   sudo virsh define libvirt-hooks/win11.xml"
echo ""
echo "5. Check PCI addresses in libvirt-hooks/kvm.conf"
echo "   Update if different hardware"
echo ""
