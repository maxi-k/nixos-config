# Secrets layout

Secrets live next to the code that uses them.

## Core pieces

- `modules/secrets/default.nix` wraps agenix and exposes `repo.secrets.files`
- `secrets.nix` at the repository root aggregates recipient rules for agenix editing/rekeying
- `modules/secrets/recipients.nix` stores reusable recipient definitions

## Pattern

- Shared module secrets live in that module's directory
- Host-specific secrets live under `hosts/<host>/secrets/`
- Each module or host can provide a nearby `secrets.nix` snippet with its recipient rules

## Current SSH example

- `modules/ssh/ssh-config.shared.age`
- `modules/ssh/secrets.nix`
- `hosts/thinkpad/secrets/ssh-config.local.age`
- `hosts/thinkpad/secrets/github-id-ed25519.age`
- `hosts/thinkpad/secrets.nix`

The `modules/ssh/default.nix` module registers those encrypted files through `repo.secrets.files` and builds `~/.ssh/config` from the shared and host-local parts.

## Adding future module secrets

For a future module like wifi, the intended layout is:

- `modules/wifi/default.nix`
- `modules/wifi/<secret>.age`
- `modules/wifi/secrets.nix`

Then the wifi module can register its decrypted target files through `repo.secrets.files`.

## Editing secrets

From the repository root:

- `agenix -e modules/ssh/ssh-config.shared.age`
- `agenix -e hosts/thinkpad/secrets/ssh-config.local.age`
- `agenix -e hosts/thinkpad/secrets/github-id-ed25519.age`

By default agenix will use the root `secrets.nix` rules file.
