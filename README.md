# Xenara OS

## Overview
Xenara OS is a custom Linux-based OS designed to be lightweight, flexible, and tailored to specific hardware. The OS will use Arch Linux as the base and replace systemd with OpenRC. It will also use `doas` instead of `sudo` and include an AI assistant integrated from kernel level to user level.

## Steps to Achieve the Goal

### 1. Set Up the Build Environment
1. Install Arch Linux on the ProBook or a VM.
2. Install `archiso`:
   ```bash
   sudo pacman -S archiso
   ```
3. Copy the `releng` profile:
   ```bash
   cp -r /usr/share/archiso/configs/releng/ ~/myos-build
   ```

### 2. Replace Systemd with OpenRC
1. **Remove systemd** from the custom ISO:
   - Edit `~/myos-build/packages.x86_64` and delete `systemd`.
   - Add `openrc`, `elogind-openrc` (for session management), and other OpenRC packages:
     ```
     openrc
     elogind-openrc
     networkmanager-openrc
     ```
2. **Configure OpenRC**:
   - Create OpenRC service symlinks for critical services (e.g., NetworkManager, udev).
   - Example: For NetworkManager:
     ```bash
     ln -s /etc/init.d/networkmanager /etc/runlevels/default/
     ```
3. **Test in a VM** before deploying to hardware (use `qemu` or `virt-manager`).

### 3. Use `doas` Instead of `sudo`
1. Remove `sudo` from the package list (`packages.x86_64`).
2. Add `opendoas`:
   ```
   opendoas
   ```
3. Configure `/etc/doas.conf` during installation:
   ```bash
   echo "permit :wheel" > /etc/doas.conf
   ```
4. Let users choose `sudo` at install time by writing a script that checks user input and installs `sudo` if requested.
5. Ensure the user has an option to ask whether they wish to use `doas` with password prompts or not. If not, make it so they can run commands requiring `doas` without the root password.

### 4. Local-Focused Design
Remove cloud dependencies:
- Strip out packages like `cloud-init`, `snapd`, or browser sync tools.
- Use offline-first apps (Ensure extras like `libreoffice` or email applications and such are optional) (e.g., `thunderbird` for email, `libreoffice`).

### 5. Integrate Your AI Assistant (Postponed)
This is the most ambitious part. Start small:
#### **Kernel-Level Integration (Advanced)**
- Write a custom kernel module to handle low-level interactions (e.g., hardware monitoring).
  **Resources**:
  - [Linux Kernel Module Programming Guide](https://tldp.org/LDP/lkmpg/2.6/html/index.html)
  - Use Python/Rust/C for lightweight code.

#### **User-Level AI** (Postponed)
1. **Build a CLI Tool First**:
   - Use Python or Rust to create a script that responds to commands (e.g., file management, system stats).
   - Example: A voice assistant using `vosk` (offline speech recognition).
2. **Optimize for Low-End Hardware**:
   - Use compiled languages (Rust, C) for performance.
   - Avoid heavy ML frameworks; consider [TinyML](https://www.tinyml.org/) for embedded AI.

### 6. Create an Installer Script that accommodates asking about all optional or extra settings.
Write a script to automate installation with user choices (e.g., `doas` vs. `sudo`).
Example workflow:
```bash
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
```

### 7. Hosting
- Use GitHub to store your ISO build scripts and code.
- For releases, enable GitHub Pages (free static hosting) or use IPFS for decentralization.
The current folder is itself a GitHub repository, so ensure proper documentation, licenses, and other necessary files are included.

### 8. Documentation and Licensing
- Ensure the repository includes a README.md file with detailed instructions.
- Include a LICENSE file with the appropriate license for the project.
- Add any additional documentation or notes in Markdown format.

### Tools You’ll Need
1. **Version Control**: `git` for tracking changes.
2. **Build Tools**: `archiso`, `mkinitcpio`.
3. **Testing**: Virtual machines (`qemu`).
4. **Documentation**: Keep notes in Markdown or a wiki.

### Learning Resources
1. [Arch Wiki](https://wiki.archlinux.org/) – Your bible for Arch-related tasks.
2. [OpenRC Documentation](https://github.com/OpenRC/openrc)
3. [Linux From Scratch](https://www.linuxfromscratch.org/) – Learn how Linux systems are built.

### Next Steps
1. **Start small**: Build a basic Arch ISO with OpenRC and `doas`.
2. **Experiment**: Test in a VM before touching hardware.
3. **Iterate**: Add your AI component incrementally. (postponed)

This will take months (or years) of work, but persistence pays off! Let me know if you need clarification on any step.
