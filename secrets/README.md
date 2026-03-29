# agenix secrets

This repository stores SSH-related secrets in two layers:

- shared secrets under `secrets/shared/`
- per-host secrets under `secrets/hosts/<hostname>/`

## Files expected by the NixOS config

The SSH config is split into two encrypted files:

- `shared/ssh-config.age` -> deployed to `~/.ssh/config.shared`
- `hosts/<hostname>/ssh-config.local.age` -> deployed to `~/.ssh/config.local`

A small generated `~/.ssh/config` then includes the decrypted shared and host-local files.

Each host can also have:

- `hosts/<hostname>/github-id-ed25519.age` -> deployed to `~/.ssh/id_ed25519`

The shared `modules/agenix.nix` module automatically installs whichever of those files exist for the current `networking.hostName`.

## Current admin recipient

Secrets are currently encrypted to a local age identity stored at `~/.config/agenix/keys.txt` so they can be edited with agenix without depending on one of the managed SSH keys.

## Add secrets for a new host

1. Ensure `shared/ssh-config.age` exists in `secrets/secrets.nix`.
2. Add new entries for `hosts/<hostname>/ssh-config.local.age` and `hosts/<hostname>/github-id-ed25519.age` in `secrets/secrets.nix`.
3. Create the encrypted files from the `secrets/` directory:
   - `agenix -e shared/ssh-config.age` (shared file, if you need to update it)
   - `agenix -e hosts/<hostname>/ssh-config.local.age`
   - `agenix -e hosts/<hostname>/github-id-ed25519.age`
4. Rebuild the host. If the encrypted files exist, they will be deployed automatically.

You can later add host-specific recipients to `secrets/secrets.nix` once you have the new host's public key material available.
