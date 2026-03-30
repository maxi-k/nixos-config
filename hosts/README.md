# Adding a new host

This file is a checklist for bringing up a new machine from this repo.

It assumes:
- the machine already has a minimal/bare NixOS install
- you can log in locally
- networking works
- this repo will live at `/home/maxi/dev/nixos-config`

## 0. On the new machine: clone the repo

Create the expected checkout location:

```bash
mkdir -p /home/maxi/dev
cd /home/maxi/dev
git clone <your nixos-config repo url> nixos-config
cd nixos-config
```

If this machine should also use local checkouts for WM development inputs, clone those too if needed:

```bash
mkdir -p /home/maxi/dev
# optional, only if you want local override inputs to be picked up by the Makefile
# git clone <tigerwm repo> /home/maxi/dev/tigerwm
# git clone <lispwm repo> /home/maxi/dev/lispwm
```

## 1. Create a host directory

Pick a directory name under `hosts/`, for example:

- `hosts/my-laptop/`

Create at least:

- `hosts/my-laptop/default.nix`
- `hosts/my-laptop/hardware-configuration.nix`

Copy the generated hardware config from the machine:

```bash
cp /etc/nixos/hardware-configuration.nix /home/maxi/dev/nixos-config/hosts/my-laptop/hardware-configuration.nix
```

## 2. Create the host config

Use an existing host as a template, e.g.:

- `hosts/thinkpad/default.nix`
- `hosts/jupyter/default.nix`

At minimum, your host config should:
- import `./hardware-configuration.nix`
- import the shared modules you want
- set `networking.hostName`
- set `system.stateVersion`

Important:
- the `hosts/<dir>/` directory name does **not** need to match the hostname
- but `networking.hostName` should be the actual hostname you want on the machine

## 3. Add the host to `flake.nix`

Edit `flake.nix` and add the new entry to `hostModules`, for example:

```nix
hostModules = {
  jupyter = ./hosts/jupyter;
  thinkpad-maxi = ./hosts/thinkpad;
  my-laptop = ./hosts/my-laptop;
  live-usb = ./hosts/live-usb.nix;
};
```

Notes:
- the attribute name (`my-laptop` above) is the flake target you rebuild with
- it does not have to be identical to `networking.hostName`, though keeping them similar is less confusing

## 4. Add host-specific secrets if needed

Host-local secrets live under the host directory, for example:

- `hosts/my-laptop/secrets/ssh-config.local.age`
- `hosts/my-laptop/secrets/github-id-ed25519.age`
- `hosts/my-laptop/secrets.nix`

Shared SSH config lives in:

- `modules/ssh/ssh-config.shared.age`
- `modules/ssh/secrets.nix`

The root `secrets.nix` auto-discovers:
- `modules/*/secrets.nix`
- `hosts/*/secrets.nix`

So for a new host you usually need:

1. create `hosts/my-laptop/secrets.nix`
2. add entries for the encrypted files there
3. create the encrypted files with `agenix`

Example `hosts/my-laptop/secrets.nix`:

```nix
let
  recipients = import ../../modules/secrets/recipients.nix;
in
{
  "hosts/my-laptop/secrets/ssh-config.local.age".publicKeys = [ recipients.maxiAdmin ];
  "hosts/my-laptop/secrets/github-id-ed25519.age".publicKeys = [ recipients.maxiAdmin ];
}
```

Then create the files:

```bash
mkdir -p hosts/my-laptop/secrets
agenix -e hosts/my-laptop/secrets/ssh-config.local.age
agenix -e hosts/my-laptop/secrets/github-id-ed25519.age
```

If the machine does not need those secrets yet, you can skip them.

## 5. Ensure the agenix identity exists on the machine

This repo expects agenix identities at:

- `/home/maxi/.config/agenix/keys.txt`

### Important: decrypting existing secrets on a new machine

For a brand-new machine, simply generating a fresh key is **not enough** to decrypt the secrets that already exist in this repo.
Those secrets are currently encrypted to the existing admin age identity.

So for the first bootstrap of a new machine, the normal procedure is:

1. copy the existing `~/.config/agenix/keys.txt` from a trusted machine that can already decrypt the repo secrets
2. place it at `/home/maxi/.config/agenix/keys.txt` on the new machine
3. ensure permissions are correct

Example:

```bash
mkdir -p /home/maxi/.config/agenix
chmod 700 /home/maxi/.config/agenix
# copy keys.txt from an existing trusted machine by whatever secure means you prefer
chmod 600 /home/maxi/.config/agenix/keys.txt
```

If you do **not** copy the existing identity first, existing encrypted files such as SSH config, SSH keys, or API keys will not decrypt.

### Generating a fresh local identity

If the file does not exist yet and you want a brand-new identity for future use, generate it with:

```bash
mkdir -p /home/maxi/.config/agenix
nix shell nixpkgs#age -c age-keygen -o /home/maxi/.config/agenix/keys.txt
```

However, that only helps after you add the new public key to the recipients and rekey the relevant secrets.
It does **not** let you decrypt already-existing secrets by itself.

If you want to use this new identity to edit/rekey secrets, add its public key to:

- `modules/secrets/recipients.nix`

Then rekey as needed.

## 6. Set the machine hostname if needed

If the currently running hostname does not match what you expect, you can still build explicitly with the flake target.

Example first rebuild:

```bash
sudo nixos-rebuild switch --flake /home/maxi/dev/nixos-config#my-laptop --impure
```

This is better than relying on `make switch` for the very first rebuild, because `make switch` uses the current runtime hostname.

## 7. After the first successful rebuild

Once the machine hostname matches the target entry and the repo is at the expected path, you can use:

```bash
cd /home/maxi/dev/nixos-config
make switch
```

Useful alternatives:

```bash
make test
make vm
```

## 8. If the machine should use Doom Emacs

The Nix config installs dependencies and a helper script, but does **not** manage your personal Doom config.

Bootstrap Doom with:

```bash
doom-install
```

That clones:
- `doomemacs` into `~/.emacs.d`
- your personal Doom config into `~/.config/doom`

Then run:

```bash
~/.emacs.d/bin/doom sync
```

## 9. Common things to verify after switch

Check that these are correct:
- hostname
- user account exists
- SSH config and key are present if expected
- graphical session starts
- `launcher`, `selector`, `change-terminal-theme`, `doom-install` are on `PATH`
- network manager / bluetooth / audio tools are available as expected

## 10. Recommended quick checklist

For a new host, the usual order is:

1. clone repo to `/home/maxi/dev/nixos-config`
2. create `hosts/<name>/`
3. copy `hardware-configuration.nix`
4. write `hosts/<name>/default.nix`
5. add host to `flake.nix`
6. add secrets if needed
7. ensure `/home/maxi/.config/agenix/keys.txt` exists
8. run:
   ```bash
   sudo nixos-rebuild switch --flake /home/maxi/dev/nixos-config#<flake-target> --impure
   ```
9. verify system
10. afterwards, use `make switch`

## 11. Notes specific to this repo

- shared Home Manager / helper logic lives in `modules/home-manager.nix`
- shared secrets plumbing lives in `modules/secrets/`
- SSH config plumbing lives in `modules/ssh/`
- workstation GUI baseline lives in `modules/desktop.nix`
- X11-specific setup lives in `modules/xorg-desktop/`
- BSPWM is in `modules/bspwm/`
- Emacs/Doom helper tooling is in `modules/emacs/`

If you forget how a host should look, use one of the existing hosts as a template.
