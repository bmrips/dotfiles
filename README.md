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

> [!IMPORTANT]
> Every command in this section has to be prefixed with `sudo`.

1. Boot into the BIOS, set Secure Boot into setup mode, and boot the installation medium. Ensure that Secure Boot is set into setup mode by running `bootctl status`.

1. Back up the EFI system partition and vendored partitions like the “DELL support” partition.

   ```sh
   dd if=/dev/nvme0n1p1 of=/media/lacie/data/HOST/ESP.img bs=4M status=progress
   mount -r /dev/nvme0n1p1 /mnt
   cp -R /mnt /media/lacie/data/HOST/ESP
   umount /mnt
   dd if=/dev/nvme0n1p2 of=/media/lacie/data/HOST/DELL_Support.img bs=4M status=progress
   ```

1. Format the drive with [disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md):

   ```sh
   disko --mode destroy,format,mount --flake ~/dotfiles#HOSTNAME
   ```

1. Restore the partitions that you backed up in the first step:

   ```sh
   cp -R /media/lacie/data/HOST/ESP/* /mnt/boot
   dd if=/media/lacie/data/HOST/DELL_Support.img of=/dev/nvme0n1p2 bs=4M status=progress
   ```

1. Transfer the most recent backup and make a writable snapshot of it at `/home`:

   ```sh
   mkdir /mnt/snapshots
   btrfs send /media/lacie/backup/HOST/BACKUP | btrfs receive /mnt/snapshots
   btrfs subvolume delete /mnt/home
   btrfs subvolume snapshot /mnt/snapshots/BACKUP /mnt/home
   ```

1. Generate and enrol Secure Boot signing keys for [lanzaboote](https://github.com/nix-community/lanzaboote):

   ```sh
   sbctl create-keys
   enroll-keys --microsoft
   mkdir -p /var/lib
   cp -R /var/lib/sbctl /mnt/var/lib
   ```

1. Install the age key: `install -Dm 0600 -o bmr -g root keys.txt /mnt/var/lib/sops/age/keys.txt`.

1. Install the configuration and add a bootloader entry:

   ```sh
   nixos-install --no-root-passwd --flake ~/dotfiles#HOSTNAME
   efibootmgr --create --disk DISK --part 1 --label NixOS --loader '\EFI\systemd\systemd-bootx64.efi'
   ```

1. Copy the dotfiles repository to the target:

   ```sh
   mkdir -p /mnt/home/bmr/.config/
   cp -R . /mnt/home/bmr/.config/home-manager
   chown -R 1000:users /mnt/home/bmr/.config/home-manager
   ```

1. Enable TPM-backed disk decryption by enrolling a TPM-guarded token for the LUKS2 encrypted volume. Additionally, add a recovery key:

   ```sh
   systemd-cryptenroll LUKS_VOLUME --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
   systemd-cryptenroll LUKS_VOLUME --wipe-slot=recovery --recovery-key
   ```

   The `--tpm2-pcrs:...+15:sha256=0...` option is combined with the `tpm2-measure-pcr=yes` decryption option in my NixOS config to prevent attacks from rogue operating systems as explained [in this blog post](https://oddlama.org/blog/bypassing-disk-encryption-with-tpm2-unlock). The effect of the countermeasure is explained in the [Arch wiki](https://wiki.archlinux.org/title/Systemd-cryptenroll#Trusted_Platform_Module).

1. Reboot and set Secure Boot into deployed mode if required.

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
