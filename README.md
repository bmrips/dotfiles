# Dotfiles

## Creating an installation device

```text
sudo dd if=$(nix build .#installer --impure --no-link --print-out-paths)/iso/*.iso of=/dev/sda bs=10M status=progress && sync
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

1. Clone the repository: `git clone https://github.com/bmrips/dotfiles ~/.config/home-manager`.

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

1. Install the age key: `sudo install -Dm 0600 -o bmr -g root keys.txt /var/lib/sops/age/keys.txt`.

1. Enable secure boot through [lanzaboote](https://github.com/nix-community/lanzaboote).

1. Enable TPM disk decryption by enrolling it into the LUKS2 encrypted volume:

```text
sudo systemd-cryptenroll <luks-volume> --tpm2-device=auto --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
```

The `--tpm2-pcrs:...+15:sha256=0...` option is combined with the `tpm2-measure-pcr=yes` decryption option in my NixOS config to prevent attacks from rogue operating systems as explained [in this blog post](https://oddlama.org/blog/bypassing-disk-encryption-with-tpm2-unlock). The effect of the countermeasure is explained in the [Arch wiki](https://wiki.archlinux.org/title/Systemd-cryptenroll#Trusted_Platform_Module).

1. Build and activate the configuration: `nixos-install --flake /mnt/home/bmr/.config/home-manager#<hostname>`.

### Standalone Home Manager

1. Install the age key `install -Dm 0600 keys.txt ~/.config/sops/age/keys.txt`.

1. Build and activate the configuration: `nix run home-manager -- switch`.

## Remaining configuration

1. Set the repo's URL to `git@github.com:bmrips/dotfiles.git` to communicate through SSH in the future.

1. Set the repo's e-mail address: `git config user.email benedikt.rips@gmail.com`.

1. Import my GPG keys from the KeePassXC database.

1. Commit the configuration for the new host.

1. Configure Firefox:

   - Sign in to my account.
   - Give each plugin the requested optional permissions.
   - Dark Reader:
     - follow the system's theme, and
     - enable per-website dark theme detection.

1. Configure Signal:

   - Hide the menu bar.
   - Minimize to the system tray.

1. Configure Spotify:

   - Minimize to the system tray

### KDE Plasma

1. Set the GTK theme to 'Breeze'.
