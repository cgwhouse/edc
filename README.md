# Everyday Carry

## VSCode

### Extension List

- VSCode Neovim
- C# Dev Kit, CSharpier
- XML, YAML
- Azure Pipelines, CloudFormation
- Markdown All in One + markdownlint + Markdown PDF
- Docker
- GitLens
- Prettier
- TODO Highlight
- Code Spell Checker
- Escape String
- Python
- Path Intellisense
- Material Icon Theme

### Config Backup

```json
{
  "todohighlight.keywords": [
    { "text": "NOTE:", "backgroundColor": "green", "color": "white" },
    { "text": "XXX:", "backgroundColor": "blue", "color": "white" }
  ],
  "vscode-neovim.compositeKeys": {
    "jk": {
      "command": "vscode-neovim.escape"
    }
  },
  "vscode-neovim.ctrlKeysForInsertMode": [
    "a",
    "d",
    "h",
    "j",
    "m",
    "o",
    "r",
    "t",
    "u",
    "w"
  ],
  "vscode-neovim.ctrlKeysForNormalMode": [
    "a",
    "b",
    "d",
    "h",
    "i",
    "j",
    "l",
    "m",
    "o",
    "r",
    "t",
    "u",
    "v",
    "x",
    "y",
    "z",
    "/",
    "]",
    "right",
    "left",
    "up",
    "down",
    "backspace",
    "delete"
  ]
}
```

## GNOME Extensions

- [Alphabetical App Grid](https://extensions.gnome.org/extension/4269/alphabetical-app-grid/)
- [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/)
- [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
- [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
- [Vitals](https://extensions.gnome.org/extension/1460/vitals/)

## Browser Extensions

- UBlock Origin
- Privacy Badger
- Bitwarden
- floccus
- SponsorBlock
- DeArrow
- Better TTV
- CanvasBlocker (FF only)

## fstab Backup

```shell
PARTUUID=90a7437c-e228-4261-9258-693d6552b88f /                           xfs   defaults,noatime           0 1
PARTUUID=e961b51d-eda2-471d-810b-8441643ce622 /efi                        vfat  umask=0077                 0 2
PARTUUID=ac90a78d-4a45-48ab-b4f1-94a3f56fb6a1 none                        swap  sw                         0 0
PARTUUID=e8365781-cac0-49a2-86c3-4ab23e69bc60 /home/cristian/second-drive ext4  defaults,noatime           0 2
UUID=7E88-53D4                                /mnt/Tank                   exfat umask=0000,defaults,nofail 0 2
UUID=676D-F75A                                /mnt/Oldman                 exfat umask=0000,defaults,nofail 0 2
```

## 3D Acceleration with KVM + NVIDIA

```text
# /etc/libvirt/qemu.conf

cgroup_device_acl = [
  "/dev/null", "/dev/full", "/dev/zero",
  "/dev/random", "/dev/urandom",
  "/dev/ptmx", "/dev/kvm",
  "/dev/nvidiactl", "/dev/nvidia0", "/dev/nvidia-modeset", "/dev/dri/renderD128"
]
seccomp_sandbox = 0
```

Then, restart the libvirtd service and run the following:

```shell
sudo virt-xml VM NAME --add-device --graphics egl-headless,gl.rendernode=/dev/dri/renderD128
```

## Vim Escape with 'jk'

```vimscript
" $HOME/.vimrc

source $VIMRUNTIME/defaults.vim

" Map key chord `jk` to <Esc>.
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
function! JKescape(key)
  if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
  if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
  let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
  return (l:timediff <= 0.05 && l:timediff >=0.001) ? "\b\e" : a:key
endfunction
inoremap <expr> j JKescape('j')
inoremap <expr> k JKescape('k')
```

## Suspend w/ Void Linux + NVIDIA + KDE Plasma

First, do this (and repeat each time the `nvidia` pkg is updated):

```shell
sudo mv /usr/libexec/elogind/system-sleep/nvidia.sh /usr/libexec/elogind/backup/
```

Then, edit `/etc/elogind/sleep.conf` to include the following:

```text
AllowSuspend=yes
SuspendByUsing=/usr/bin/zzz
HibernateByUsing=/usr/bin/ZZZ
```

## BTRFS / Snapshots

Guide which can be followed for all distributions, as long as root subvolume is created as `@rootfs`: [snapper-in-debian-guide](https://github.com/david-cortes/snapper-in-debian-guide)

After doing `mkfs`, mount the partition the standard way, then create root subvolume:

```shell
btrfs su cr /mnt/@rootfs
```

Unmount, then re-mount the new subvolume:

```shell
mount -o defaults,subvol=/@rootfs /dev/??? /mnt
```

### Void

Void requires several extra, manual steps.

If we can't login to the desktop after setting up the @tmp subvolume, check permissions of `/tmp` with `ls -ld /tmp`. Anything other than `drwxrwxrwt` is wrong. Fix with:

```shell
sudo chmod 1777 /tmp
sudo chown root:root /tmp
```

#### Manual snapper-rollback

To use `snapper-rollback`, we need to install the `btrfsutils` Python library. First install `libbtrfsutil-devel`. Then, set up venv:

```shell
sudo mkdir -p /opt/btrfs-tools/venv
sudo python3 -m venv /opt/btrfs-tools/venv
sudo /opt/btrfs-tools/venv/bin/pip install --upgrade pip
sudo /opt/btrfs-tools/venv/bin/pip install btrfsutil
```

Update the shebang in `snapper-rollback.py`:

```python
#!/opt/btrfs-tools/venv/bin/python3
import btrfsutil
```

#### Manual btrfs-assistant

The btrfs-assistant GUI will need to be built from source, Ubuntu instructions can be roughly followed:

```text
1. Install the prerequisites: `sudo apt install git cmake fonts-noto qt6-base-dev qt6-base-dev-tools g++ libbtrfs-dev libbtrfsutil-dev pkexec qt6-svg-dev qt6-tools-dev`
2. Download the tar.gz from the latest version [here](https://gitlab.com/btrfs-assistant/btrfs-assistant/-/tags)
3. Untar the archive and cd into the directory
4. `cmake -B build -S . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE='Release'`
5. `make -C build`
6. `sudo make -C build install`
```

We may need to append `-DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS -Wno-error=deprecated-declarations"` to the cmake step to get it to build.

#### Alias suggestions

Lastly, xbps doesn't have any support for hooks, so we'll have to manually create snapshots before modifying system packages. Something like these aliases may help:

```shell
# Pre and Post snapshots for updates
alias pkgup="sudo snapper create --command 'sudo xbps-install -Su'"

# Pre snapshots for installing new packages
alias pkgin="sudo snapper create --cleanup-algorithm timeline && sudo xbps-install "

# Pre snapshots for removing packages
alias pkgun="sudo snapper create --cleanup-algorithm timeline && sudo xbps-remove -R "
```

## LazyVim Config Backup

```lua
-- options.lua
vim.g.loaded_perl_provider = 0 -- Disable perl
vim.g.loaded_ruby_provider = 0 -- Disable ruby
vim.g.autoformat = false -- Disable format on save
vim.opt.relativenumber = false -- Disable relative line numbers

--keymaps.lua
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
```

## Setup Guide for ISO-based (Old) Games

To drop a file from host into VM when virtiofs not available, create ISO and then mount:

```shell
mkisofs -o <output file name>.iso <target file>
```

Dealing with `.bin` and `.cue` files, using Bioscopia as an example:

1. Convert CD1 .bin and .cue to .iso using:

   ```shell
   bchunk <bin file>.bin <cue file>.cue <name of thing to output>
   ```

2. Re-extract CD1 .iso so you have the real contents in a folder, create .zip
3. `mkisofs` this .zip and create folder on Desktop with CD1 contents
4. Unmount CD1 from VM, `bchunk` CD2 and mount to VM
5. Install QuickTime and game from CD1 Desktop folder in VM

## Tmux Config

```shell
# ~/.tmux.conf

# Options to make tmux more pleasant
set -g mouse on
set -g default-terminal "tmux-256color"

# Configure the catppuccin plugin
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"

# Load catppuccin
run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
# For TPM, instead use `run ~/.config/tmux/plugins/tmux/catppuccin.tmux`

# Make the status line pretty and add some modules
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_user}"
set -ag status-right "#{E:@catppuccin_status_directory}"

# replace C-b by C-a
set -gu prefix2
unbind C-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Start windows and panes index at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Ensure window index numbers get reordered on delete
set-option -g renumber-windows on

# Neovim :checkhealth
set-option -sg escape-time 10
set-option -g focus-events on
set-option -a terminal-features 'xterm-256color:RGB'
```

## Random Commands

`ln -sf /path/to/real/file /desired/location/of/symlink`

`sudo chown -R username:username absolute-path-to-folder`

`sudo grub-mkconfig -o /boot/grub/grub.cfg`
