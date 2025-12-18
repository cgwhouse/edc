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
- XBrowserSync
- SponsorBlock
- DeArrow
- Better TTV
- CanvasBlocker (FF only)

## fstab Backup

```shell
PARTUUID=e961b51d-eda2-471d-810b-8441643ce622   /efi                          vfat    umask=0077		    0 2
PARTUUID=ac90a78d-4a45-48ab-b4f1-94a3f56fb6a1   none                          swap    sw			    0 0
PARTUUID=90a7437c-e228-4261-9258-693d6552b88f   /                             xfs     defaults,noatime		    0 1
PARTUUID=e8365781-cac0-49a2-86c3-4ab23e69bc60   /home/cristian/second-drive   ext4    defaults,noatime		    0 2
UUID=7E88-53D4                                  /mnt/Tank                     exfat   umask=0000,defaults,nofail    0 2
UUID=676D-F75A                                  /mnt/Oldman                   exfat   umask=0000,defaults,nofail    0 2
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

Dealing with `.bin` and `.cue` files, using [Bioscopia]() as an example:

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
