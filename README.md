# Dotfiles

## Bootstrapping

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

   ```bash
   NIX_FIRST_BUILD_UID=302 sh <(curl -L https://nixos.org/nix/install)
   ```

1. On systems other than NixOS, enable `auto-optimise-store` and `use-xdg-base-directories` in `/etc/nix/nix.conf`.

1. Clone the repository:

   ```bash
   git clone https://github.com/bmrips/dotfiles ~/.config/home-manager
   ```

1. Set the repo's URL to `git@github.com:bmrips/dotfiles.git` to communicate through SSH in the future.

1. Set the repo's e-mail address: `git config user.email benedikt.rips@gmail.com`.

1. Generate an Age key for sops-nix:

   - Generate the key: `nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt`.
   - Add it to `.sops.yaml`.
   - Update the secrets: `nix run nixpkgs#sops -- updatekeys {home-manager,nixos}/config/secrets.yaml`.

1. Reuse an existing host configuration or create a new one.

1. Build and install the host configuration:

   - On NixOS: `nixos-rebuild --use-remote-sudo switch`.
   - For standalone Home Manager: `nix run home-manager/master -- switch`.

## After bootstrapping

1. Enable automatic development shell activation through direnv: `direnv allow ~/.config/home-manager`.

1. Store the KeePassXC database password in the secret manager: `nix run nixpkgs#libsecret -- store --label="Password for the KeePassXC database" keepassxc password`

1. Start KeePassXC and import my GPG key from the private database.

1. Configure Firefox:

   - Sign in to my account.
   - Give each plugin the requested optional permissions.
   - Auto-Sorting Bookmarks: enable.
   - Dark Reader:
     - follow the system's theme, and
     - enable per-website dark theme detection.
   - GitHub Refined: set an API token.
   - KeePassXC: connect to the database.
   - LanguageTool:
     - sign in with my account,
     - set German as my mother tongue,
     - set English and German as my preferred languages.
   - Simple Translate:
     - Enable the DeepL API, and
     - set German as primary and English as secondary language.
   - Skip Redirect: synchronize the settings.
   - Tab Session Manager:
     - enable tree-style tab integration,
     - disable auto-save,
     - do not track newly opened windows,
     - sync my sessions,
     - set the save button behaviour to only save the current window.
