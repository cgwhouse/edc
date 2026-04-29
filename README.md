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
# "second drive"
UUID=???                                      /???/???                    ext4  defaults,noatime           0 2

# HDDs
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

## Backports for Desktop Debian

- Kernel + headers
- Firmware
- Pipewire
- CPU Microcode
- Flatpak
- Filesystem utils

## APT Pinning Example

```text
# /etc/apt/preferences.d/99-nvidia

Package: *
Pin: origin "developer.download.nvidia.com"
Pin-Priority: 1001
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

## Firewall Config

```shell
# Deny all incoming traffic to the host by default
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH so you don't lock yourself out
sudo ufw allow ssh

# Enable the firewall
sudo ufw enable
```

## SSH Config Example

```plaintext
Host some-aliases-for-host
    HostName ip-or-dns-goes-here
    User username-to-ssh-with
    IdentityFile path/to/id
```

## Unbound with Cloudflare Upstream

```text
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to no if you don't have IPv6 connectivity
    do-ip6: yes

    # You want to leave this to no unless you have *native* IPv6.
    prefer-ip6: no

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10

    # Ensure no reverse queries to non-public IP ranges (RFC6303 4.2)
    private-address: 192.0.2.0/24
    private-address: 198.51.100.0/24
    private-address: 203.0.113.0/24
    private-address: 255.255.255.255/32
    private-address: 2001:db8::/32

    # --- HYBRID CONFIGURATION ADDITION ---
    # Point Unbound to the system's root certificates to verify the TLS connection
    tls-cert-bundle: "/etc/ssl/certs/ca-certificates.crt"

# --- UPSTREAM FORWARDING RULES ---
forward-zone:
    # The "." means "all queries"
    name: "."
    # Enable DNS-over-TLS
    forward-tls-upstream: yes
    
    # Cloudflare Primary and Secondary IPv4
    forward-addr: 1.1.1.1@853#cloudflare-dns.com
    forward-addr: 1.0.0.1@853#cloudflare-dns.com
    
    # Cloudflare Primary and Secondary IPv6 (Included since do-ip6 is 'yes')
    forward-addr: 2606:4700:4700::1111@853#cloudflare-dns.com
    forward-addr: 2606:4700:4700::1001@853#cloudflare-dns.com
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
