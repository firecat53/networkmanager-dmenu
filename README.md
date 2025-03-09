# Networkmanager-dmenu

Manage NetworkManager connections with dmenu, [Rofi][1], [Bemenu][2],
[Wofi][7] or [fuzzel][8] instead of nm-applet

**NOTE**

> PR #124 changes `rofi_highlight` to `highlight` in `config.ini`.

## Features

- Connect to existing NetworkManager wifi or wired connections
- Connect to new wifi connections. Requests passphrase if required
- Connect to _existing_ VPN, Wireguard, GSM/WWAN and Bluetooth connections
- Enable/Disable wifi, WWAN, bluetooth and networking
- Launch nm-connection-editor GUI
- Support for multiple wifi adapters
- Optional Pinentry support for secure passphrase entry
- Delete existing connections
- Rescan wifi networks
- Uses notify-send for notifications if available
- Start/stop/delete existing NetworkManager Hotspots

![Screencast](nmdm.gif)

## Installation

- Copy script somewhere into $PATH OR

  - Archlinux: [AUR package][3] OR
  - Gentoo: [Woomy Overlay][4]
  - Nix: [Nix Packages][9]

## Requirements

1. Python 3.7+
2. NetworkManager
3. Dmenu (X), Rofi (X or XWayland), Wofi (Wayland) or Bemenu (X or Wayland)
4. Python gobject (PyGObject, python-gobject, etc.)
5. (Debian/Ubuntu based distros) libnm0 (libnm-util-dev on older distributions)
   and gir1.2-nm-1.0 (you have to explicitly install the latter on Debian Sid)
6. (optional) The network-manager-applet or nm-connection-editor package,
   depending on distro (in order to launch the GUI connection editor, if
   desired. The applet does _not_ need to be started.)
7. (optional) Pinentry. Make sure to set which flavor of pinentry command to use
   in the config file.
8. (optional) ModemManager for WWAN support.
9. (optional) notify-send for notifications (connected, disconnected, etc.)
10. (optional) bluez package for bluetooth control

## Configuration 

- To customize behavior, copy config.ini.example to
  ~/.config/networkmanager-dmenu/config.ini and edit.
- Alternatively, specify a custom config file location using:
  - Command line: `--config /path/to/config.ini`
  - Environment variable: `NM_DMENU_CONFIG=/path/to/config.ini networkmanager_dmenu`
  - The command line flag takes precedence over the environment variable
- All theming is done through the respective menu programs. Set `dmenu_command`
  with the desired options, including things like `-i` for case insensitivity.
  See config.ini.example for examples.
- If using dmenu for passphrase entry (pinentry not set), dmenu options in the
  `[dmenu_passphrase]` section of config.ini will set the normal foreground and
  background colors to be the same to obscure the passphrase. The [Suckless
  password patch][6] `-P` option is supported if that patch is installed. Rofi,
  Wofi and Bemenu will use their respective flags for passphrase entry.
- Set default terminal (xterm, urxvtc, etc.) command in config.ini if desired.
- Saved connections can be listed if desired. Set `list_saved = True` under
  `[dmenu]` in config.ini. If set to `False`, saved connections are still
  accessible under a "Saved connections" sub-menu.
- If desired, copy the networkmanager_dmenu.desktop to /usr/share/applications
  or ~/.local/share/applications.
- If you want to run the script as $USER instead of ROOT
    1. Set [PolicyKit permissions][5]. The script is usable for connecting to
       pre-existing connections without setting these, but you won't be able to
       enable/disable networking or add new connections.
- For bluetooth control, there are two options:
    1. If bluez is installed and the bluetooth service is running, no further
       action is needed.
    2. If not, the user needs to have access to `/dev/rfkill`. On some distros
       (e.g. Archlinux), `/dev/rfkill` belongs to a group such as `rfkill`. In
       this case, ensure $USER belongs to that group. For other distros (e.g.
       Fedora), you can use udev to ensure `/dev/rfkill` belongs to a group. For
       example, create `/etc/udev/rules.d/10-rfkill.rules`:

               KERNEL=="rfkill", GROUP="wheel", MODE="0664"
    
       and then ensure $USER belongs to the `wheel` group.

### Config.ini values

| Section              | Key                | Default                | Notes                                            |
|----------------------|--------------------|------------------------|--------------------------------------------------|
| `[dmenu]`            | `compact`          | `False`                |                                                  |
|                      | `dmenu_command`    | `dmenu`                | Command can include arguments                    |
|                      | `list_saved`       | `False`                |                                                  |
|                      | `pinentry`         | None                   |                                                  |
|                      | `active_chars`     | ==                     | Prefix of active connection                      |
|                      | `highlight`        | `False`                | Only applicable to rofi / wofi                   |
|                      | `highlight_fg`     | None                   | Only applicable to wofi                          |
|                      | `highlight_bg`     | None                   | Only applicable to wofi                          |
|                      | `highlight_bold`   | `True`                 | Only applicable to wofi                          |
|                      | `wifi_chars`       | None                   | String of 4 unicode characters                   |
|                      | `wifi_icons`       | None                   | String of icon characters                        |
|                      | `format`           | (depends on `compact`) | Python-style format string                       |
| `[pinentry]`         | `description`      | `Get network password` |                                                  |
|                      | `prompt`           | `Password:`            |                                                  |
| `[dmenu_passphrase]` | `obscure`          | `False`                |                                                  |
|                      | `obscure_color`    | `#222222`              | Only applicable to dmenu                         |
| `[editor]`           | `gui_if_available` | `True`                 |                                                  |
|                      | `gui`              | `nm-connection-editor` |                                                  |
|                      | `terminal`         | `xterm`                | Can include terminal arguments                   |
| `[nmdm]`             | `rescan_delay`     | `5`                    | Adjust delay in re-opening nmdm following rescan |

## Usage

`networkmanager_dmenu [-h] [--config CONFIG_PATH] <menu args>`

- Run script or bind to keystroke combination
- If desired, menu options can be passed on the command line instead of or in
  addition to the config file. These will override options in the config file.
- Networkmanager_dmenu cannot create hotspots, but can manage existing ones. To
  create a new NetworkManager hotspot and show a QR Code with the password:
        
        nmcli device wifi hotspot ifname wlp0s20f3 ssid testing password pass123456 band a
        nmcli connection up hotspot (or use networkmanager_dmenu to enable)
        nmcli device wifi show-password

  This may not work for your setup.  [Linux-wifi-hotspot][10] is an option if
  straight NetworkManager wifi sharing doesn't work for you.  Unfortunately,
  these hotspots cannot be managed with networkmanager_dmenu.

## MIT License

[1]: https://davedavenport.github.io/rofi/ "Rofi"
[2]: https://github.com/Cloudef/bemenu "Bemenu" 
[3]: https://aur.archlinux.org/packages/networkmanager-dmenu-git/ "AUR Package" 
[4]: https://github.com/Woomy4680-exe/Woomy-overlay "Woomy Overlay" 
[5]: https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions "PolicyKit permissions"
[6]: https://tools.suckless.org/dmenu/patches/password/ "Suckless password patch" 
[7]: https://hg.sr.ht/~scoopta/wofi "Wofi"
[8]: https://codeberg.org/dnkl/fuzzel "Fuzzel"
[9]: https://search.nixos.org/packages? "Nix Packages"
[10]: https://github.com/lakinduakash/linux-wifi-hotspot
