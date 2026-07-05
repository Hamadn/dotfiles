# dotfiles

Arch Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Package | Config |
|---------|--------|
| **polybar** | Forest theme with animated petiglyph glyphs |
| **zsh** | `.zshrc`, `.zshenv`, `.p10k.zsh` — oh-my-zsh + powerlevel10k |
| **nvim** | Editor config |
| **i3** | Window manager |
| **tmux** | Terminal multiplexer |
| **wezterm** | Terminal emulator |
| **fastfetch** | System info |
| **mpv** | Video player |
| **ncmpcpp** | Music player |
| **qutebrowser** | Browser |
| **petiglyph** | Source files for the animated font |
| **Wallpapers** | Background images |
| **libvirt-hooks** | GPU passthrough scripts for win11 VM |

## Quick start (fresh Arch install)

```bash
sudo pacman -S git stow yay
git clone https://github.com/you/dotfiles ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## setup.sh automates

1. Install all packages (repo + AUR)
2. Clone oh-my-zsh, custom plugins, powerlevel10k, fzf-git.sh
3. Install petiglyph Package font
4. Stow all configs into place
5. Install libvirt GPU passthrough hooks

## Post-install manual steps

Printed at the end of `setup.sh`:

1. **Kernel cmdline** — add `intel_iommu=on iommu=pt ibt=off nvidia_drm.modeset=1` to GRUB
2. **Enable libvirt services** — `virtqemud.socket`, `virtnetworkd.socket`, `virtstoraged.socket`
3. **Start default network + pool** — NAT networking and storage
4. **Restore VM** — copy ROM/ACPI files, define win11 VM
5. **Update PCI addresses** in `kvm.conf` if hardware differs

## Adding a new app

```bash
cd ~/dotfiles
mkdir -p appname/.config/appname
mv ~/.config/appname/* appname/.config/appname/
rm -rf ~/.config/appname
stow appname
git add appname && git commit -m "add appname config"
```

Add `appname` to the `for pkg in` loop in `setup.sh`.
