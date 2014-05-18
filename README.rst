Nmcli-dmenu
===============

Small script to manage NetworkManager connections with dmenu instead of nm-applet

Features
--------

- Connect to existing NetworkManager wifi or wired connections
- Connect to new wifi connections. Requests passphrase if required
- Connect to _existing_ VPN connections 
- Enable/Disable networking
- Launch nm-connection-editor GUI

License
-------

- MIT

Requirements
------------

1. Python 2.7+ or 3.2+
2. NetworkManager
3. Dmenu
4. (optional) The network-manager-applet package (in order to launch the GUI connection editor, if desired. The nm-applet does _not_ need to be started.)

Installation
------------

- To customize dmenu appearance, copy config.ini.example to ~/.config/networkmanager-dmenu/config.ini and edit.
- Copy script somewhere in $PATH
- If you want to run the script as $USER instead of ROOT, set `PolicyKit permissions`_. The script is usable for connecting to pre-existing connections without setting these, but you won't be able to enable/disable networking or add new connections.

OR

- Archlinux `AUR package`_

Usage
-----

- Run script or bind to keystroke combination

.. _PolicyKit permissions: https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions
.. _AUR Package: https://aur.archlinux.org/packages/networkmanager-dmenu-git/
