#!/bin/bash

# Ask user for preferences
read -p "Use doas instead of sudo? [Y/n]: " choice
if [[ $choice =~ ^[Yy]$ ]]; then
  pacman -S opendoas
  read -p "Enable doas without password prompts? [Y/n]: " doas_no_pass
  if [[ $doas_no_pass =~ ^[Yy]$ ]]; then
    echo "permit nopass :wheel" > /etc/doas.conf
  else
    echo "permit :wheel" > /etc/doas.conf
  fi
else
  pacman -S sudo
fi

read -p "Install LibreOffice? [Y/n]: " libreoffice_choice
if [[ $libreoffice_choice =~ ^[Yy]$ ]]; then
  pacman -S libreoffice
fi

read -p "Install Thunderbird? [Y/n]: " thunderbird_choice
if [[ $thunderbird_choice =~ ^[Yy]$ ]]; then
  pacman -S thunderbird
fi

# Additional installation steps can be added here

# Additional installation steps can be added here

echo "Installation completed."
