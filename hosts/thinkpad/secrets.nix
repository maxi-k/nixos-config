let
  recipients = import ../../modules/secrets/recipients.nix;
in
{
  "hosts/thinkpad/secrets/ssh-config.local.age".publicKeys = [ recipients.maxiAdmin ];
  "hosts/thinkpad/secrets/github-id-ed25519.age".publicKeys = [ recipients.maxiAdmin ];
}
