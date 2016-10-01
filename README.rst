Nmcli-dmenu
===============

Small script to manage NetworkManager connections with dmenu instead of nm-applet

Features
--------

- Connect to existing NetworkManager wifi or wired connections
- Connect to new wifi connections. Requests passphrase if required
- Connect to _existing_ VPN connections 
- Enable/Disable wifi
- Enable/Disable networking
- Launch nm-connection-editor GUI
- Support for multiple wifi adapters
- Optional Pinentry support for secure passphrase entry

License
-------

- MIT

Requirements
------------

1. Python 2.7+ or 3.2+
2. NetworkManager
3. Dmenu. Basic support is included for Rofi_, but most Rofi configuration/theming should be done via Xresources.
4. Python gobject (PyGObject, python-gobject, etc.)
5. (optional) The network-manager-applet package (in order to launch the GUI connection editor, if desired. The nm-applet does _not_ need to be started.)
6. (optional) Pinentry. Make sure to set which flavor of pinentry command to use in the config file.

Installation
------------

- If using networkmanager < version 0.9.10 you _must_ checkout the 'networkmanager-0.9.8' branch. Some of the nmcli terminology changed with 0.9.10 and is _not_ compatible with previous versions.
- Set your dmenu_command in config.ini if it's not 'dmenu' (for example dmenu_run or rofi). The alternate command should still respect the -l, -p and -i flags.
- To customize dmenu appearance, copy config.ini.example to ~/.config/networkmanager-dmenu/config.ini and edit.
- Set default terminal (xterm, urxvtc, etc.) command in config.ini if desired.
- If using Rofi, you can try some of the command line options in config.ini or set them using the `dmenu_command` setting, but I haven't tested most of them so I'd suggest configuring via .Xresources where possible. 
- Copy script somewhere in $PATH
- If desired, copy the nmcli_dmenu.desktop to /usr/share/applications or ~/.local/share/applications.
- If you want to run the script as $USER instead of ROOT, set `PolicyKit permissions`_. The script is usable for connecting to pre-existing connections without setting these, but you won't be able to enable/disable networking or add new connections.

OR

- Archlinux `AUR package`_

Usage
-----

- Run script or bind to keystroke combination

.. _PolicyKit permissions: https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions
.. _AUR Package: https://aur.archlinux.org/packages/networkmanager-dmenu-git/

TODO
----

1. Add ability to delete connections

.. _Rofi: https://davedavenport.github.io/rofi/
