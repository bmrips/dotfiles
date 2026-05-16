# Dotfiles

## Creating an Installation Device

```sh
nix build .#installer.iso-installer --impure --no-link --print-out-paths
sudo dd if=result/iso/IMAGE.iso of=/dev/sda bs=10M status=progress && sync
```

### Debugging the Installer Image

In order to debug the installer image, build its QEMU variant and run it via QEMU as a virtual machine.

```sh
nix build .#installer.qemu --impure
nix shell nixpkgs#qemu -c qemu-system-x86_64 -enable-kvm -nic user,model=virtio -vga virtio -m 8G -smp cpus=4 -snapshot result/*.qcow2
```

Note, that changes are not persisted across reboots. In order to persist changes, you first need to make the image writable by copying it from the Nix store to some writable location and setting write permissions for the owner. Then, run it with `-drive` instead of `-snapshot` to write changes to the image:

```sh
install -m 644 result/*.qcow2 .
nix shell nixpkgs#qemu -c qemu-system-x86_64 -enable-kvm -nic user,model=virtio -vga virtio -m 8G -smp cpus=4 -drive file=IMAGE.qcow2
```

## Bootstrapping Nix on macOS

1. If necessary, bootstrap Nix.

   On macOS, the installation script may fail with the error:

   ```txt
   ---- sudo execution ------------------------------------------------------------
   I am executing:

       $ sudo /usr/bin/dscl . create /Users/_nixbld1 UniqueID 301

   Creating the Nix build user (#1), _nixbld1

   <main> attribute status: eDSRecordAlreadyExists
   <dscl_cmd> DS Error: -14135 (eDSRecordAlreadyExists)
   ```

   The cause of [this issue](https://github.com/NixOS/nix/issues/6153#issuecomment-1068508475) is that Nix assumes user ID 301, the next one after your user ID (300), to be vacant but it being assigned to another already. To tell the installation script the first vacant user ID that it can assign to the build users, you have to set the `NIX_FIRST_BUILD_UID` environment variable:

   ```sh
   NIX_FIRST_BUILD_UID=302 sh <(curl -L https://nixos.org/nix/install)
   ```

1. Enable `auto-optimise-store` and `use-xdg-base-directories` in `/etc/nix/nix.conf`.

## Installation

1. Clone the repository: `git clone https://github.com/bmrips/dotfiles [~/.config/home-manager]`.

1. Enable the development shell through direnv: `direnv allow ~/.config/home-manager`.

1. Roll-out the secrets contained in this repo to this machine:

   - Generate a new key pair: `age-keygen -o keys.txt`.

   - Add the public key to `.sops.yaml`.

   - Encrypt the secrets with the added key:

     ```sh
     SOPS_AGE_KEY_FILE=keys.txt sops updatekeys {home-manager,nixos}/config/secrets.yaml
     ```

1. Reuse an existing host configuration or create a new one.

### NixOS

1. Format the drive with [disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md):

   ```sh
   sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#HOSTNAME
   ```

1. In case of a re-installation, copy the most recent backup to the snapshots directory and make a writable snapshot of it at `/home`:

   ```sh
   sudo btrfs send /media/lacie/HOST/BACKUP | sudo btrfs receive /mnt/snapshots
   sudo btrfs subvolume snapshot /mnt/snapshots/BACKUP /mnt/home
   ```

1. Install the age key: `sudo install -Dm 0600 -o bmr -g root keys.txt /mnt/var/lib/sops/age/keys.txt`.

1. Generate signing keys for [lanzaboote](https://github.com/nix-community/lanzaboote): `sudo nixos-enter -c 'nix run ixpkgs#sbctl --- create-keys`.

1. Install the configuration and add a bootloader entry:

   ```sh
   sudo nixos-install --no-root-passwd --flake /mnt/home/bmr/.config/home-manager#HOSTNAME
   sudo efibootmgr --create --disk DISK --part 1 --label NixOS --loader '\EFI\systemd\systemd-bootx64.efi'
   ```

1. Copy the dotfiles repository to the target:

   ```sh
   sudo mkdir -p /mnt/home/bmr/.config/
   sudo cp -r . /mnt/home/bmr/.config/home-manager
   ```

1. Reboot into the BIOS, set Secure Boot into setup mode, and boot into NixOS. Ensure that Secure Boot is set into setup mode by running `bootctl status`.

1. Enrol your signing keys: `sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft`.

1. Reboot once more and set Secure Boot into deployed mode if required. This ensures that the enrolment succeeded.

1. Enable TPM-backed disk decryption by enrolling a TPM-guarded token for the LUKS2 encrypted volume. Additionally, add a recovery key:

   ```sh
   sudo systemd-cryptenroll LUKS_VOLUME --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
   sudo systemd-cryptenroll LUKS_VOLUME --wipe-slot=recovery --recovery-key
   ```

   The `--tpm2-pcrs:...+15:sha256=0...` option is combined with the `tpm2-measure-pcr=yes` decryption option in my NixOS config to prevent attacks from rogue operating systems as explained [in this blog post](https://oddlama.org/blog/bypassing-disk-encryption-with-tpm2-unlock). The effect of the countermeasure is explained in the [Arch wiki](https://wiki.archlinux.org/title/Systemd-cryptenroll#Trusted_Platform_Module).

### Standalone Home Manager

1. Install the age key `install -Dm 0600 keys.txt ~/.config/sops/age/keys.txt`.

1. Build and activate the configuration: `nix run home-manager -- switch`.

## Remaining Configuration

1. Set the repo's URL to `git@github.com:bmrips/dotfiles.git` to communicate through SSH in the future.

1. Set the repo's e-mail address: `git config user.email benedikt.rips@gmail.com`.

1. Import my GPG keys from the KeePassXC database.

1. Commit the configuration for the new host.

1. Sign in to my Firefox account.

1. Configure Spotify to minimize itself to the system tray.

### KDE Plasma

1. Set the GTK theme to 'Breeze'.
