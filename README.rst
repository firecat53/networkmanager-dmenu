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

Installation
------------

- Edit dmenu parameters if desired
- Copy script somewhere in $PATH
- If you want to run the script as $USER instead of ROOT, set `PolicyKit permissions`_. The script is usable for connecting to pre-existing connections without setting these, but you won't be able to enable/disable networking or add new connections.

Usage
-----

- Run script or bind to keystroke combination

.. _PolicyKit permissions: https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions
