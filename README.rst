Networkmanager-dmenu
====================

Manage NetworkManager connections with dmenu, Rofi_ or Bemenu_ instead of nm-applet

Features
--------

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

License
-------

- MIT

Requirements
------------

1. Python 3.7+
2. NetworkManager
3. Dmenu, Rofi or bemenu
4. Python gobject (PyGObject, python-gobject, etc.)
5. (Debian/Ubuntu based distros) libnm-util-dev and gir1.2-nm-1.0 (you have to
   explicitly install the latter on Debian Sid)
6. (optional) The network-manager-applet package (in order to launch the GUI
   connection editor, if desired. The nm-applet does _not_ need to be started.)
7. (optional) Pinentry. Make sure to set which flavor of pinentry command to use
   in the config file.
8. (optional) ModemManager for WWAN support.
9. (optional) notify-send for notifications (connected, disconnected, etc.)

Installation
------------

- Copy script somewhere in $PATH OR

  - Archlinux: `AUR package`_ OR
  - Gentoo: `Woomy Overlay`_

- To customize behavior, copy config.ini.example to
  ~/.config/networkmanager-dmenu/config.ini and edit.
- All theming is done through the respective menu programs. Set `dmenu_command`
  with the desired options, including things like `-i` for case insensitivity.
  See config.ini.example for examples.
- If using dmenu for passphrase entry (pinentry not set), dmenu options in the
  [dmenu_passphrase] section of config.ini will set the normal foreground and
  background colors to be the same to obscure the passphrase. The `Suckless
  password patch`_ `-P` option is supported if that patch is installed. Rofi and
  bemenu will use their respective flags for passphrase entry.
- Set default terminal (xterm, urxvtc, etc.) command in config.ini if desired.
- Saved connections can be listed if desired. Set `list_saved = True` under
  `[dmenu]` in config.ini. If set to `False`, saved connections are still
  accessible under a "Saved connections" sub-menu.
- If desired, copy the networkmanager_dmenu.desktop to /usr/share/applications
  or ~/.local/share/applications.
- If you want to run the script as $USER instead of ROOT, set `PolicyKit
  permissions`_. The script is usable for connecting to pre-existing connections
  without setting these, but you won't be able to enable/disable networking or
  add new connections.

Usage
-----

- Run script or bind to keystroke combination
- If desired, menu options can be passed on the command line instead of or in
  addition to the config file. These will override options in the config file.

.. _PolicyKit permissions: https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions
.. _AUR Package: https://aur.archlinux.org/packages/networkmanager-dmenu-git/
.. _Woomy Overlay: https://github.com/Woomy4680-exe/Woomy-overlay 
.. _Rofi: https://davedavenport.github.io/rofi/
.. _Bemenu: https://github.com/Cloudef/bemenu
.. _Suckless password patch: https://tools.suckless.org/dmenu/patches/password/
