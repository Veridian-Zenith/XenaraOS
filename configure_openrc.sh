#!/bin/bash

# Create OpenRC service symlinks for critical services within the ISO
ln -s /etc/init.d/networkmanager /etc/runlevels/default/
ln -s /etc/init.d/udev /etc/runlevels/default/

# Additional OpenRC configuration if needed
# For example, you might want to enable other services or configure OpenRC settings

# Additional OpenRC configuration if needed
# For example, you might want to enable other services or configure OpenRC settings

echo "OpenRC configuration completed."
