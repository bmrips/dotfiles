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

1. Enable `auto-optimise-store` and `use-xdg-base-directories` (potentially in `/etc/nix/nix.conf`).

1. Clone the repository:

   ```bash
   git clone https://github.com/f1rstlady/user-config --bare
   mv user-config.git .git
   ```

1. Set the repo's url to `git@github.com:f1rstlady/user-config.git` to communicate through SSH in the future.

1. Set the repo's e-mail address: `git config user.email benedikt.rips@gmail.com`.

1. Deactivate listing untracked files in `git status` by setting `git config status.showUntrackedFiles no`.

1. Check for any tracked files that would be overwritten by the repo: `git status`. If no file were overwritten, reset the working directory: `git reset --hard`.

1. Reuse an existing host configuration or create a new one.

1. Install home-manager: `nix run home-manager/master -- switch`.

1. Install pre-commit hooks into this repo: `pre-commit install -f`.

1. Store the KeePassXC database password in the secret manager: `nix run nixpkgs#libsecret -- store --label="Password for the KeePassXC database" keepassxc password`

1. Start KeePassXC and import my GPG key from the private database.

1. Configure Firefox:

   - Sign in to my account.
   - Give each plugin the requested optional permissions.
   - Auto-Sorting Bookmarks: enable.
   - Dark Reader:
     - follow the system's theme, and
     - enable per-website dark theme detection.
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

## macOS specific customization

1. Disable accent character suggestions when pressing and holding keys.

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```
