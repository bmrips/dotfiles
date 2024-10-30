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

1. Enter a nix-shell with git and openssh: `nix-shell -p git openssh`.

1. Generate an SSH key.

1. Register it in GitHub.

1. Clone the repository:

   ```bash
   git clone git@github.com:f1rstlady/user-config.git --bare
   mv user-config.git .git
   ```

1. Set the repo's e-mail address: `git config user.email benedikt.rips@gmail.com`.

1. Deactivate listing untracked files in `git status` by setting `git config status.showUntrackedFiles no`.

1. Check for any tracked files that would be overwritten by the repo: `git status`. If no file would be overwritten, reset the working directory: `git reset --hard`.

1. Install home-manager:

   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   ```

1. Install pre-commit hooks into this repo: `pre-commit install -f`.

1. Start KeepassXC and import my GPG key from the private database.

1. Configure Firefox:

   - Enable pre-installed plugins.
   - Sign in to my account.
   - Configure the tab session manager:
     - enable tree-style tab integration,
     - sync my sessions,
     - disable auto-save.
   - Synchronise the skip-redirect plugin's settings.
   - Configure the dark reader plugin follow the system's theme.
   - Enable per-website dark theme detection in the dark reader plugin.
   - For "Simple Translate":
     - Enable the DeepL API,
     - set German as primary and English as secondary language.

## macOS specific customization

1. Disable accent character suggestions when pressing and holding keys.

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```
