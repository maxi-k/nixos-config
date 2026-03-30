let
  rcv = import ../../modules/secrets/recipients.nix;
in
{
  "hosts/thinkpad/secrets/ssh-config.local.age".publicKeys = rcv.all;
  "hosts/thinkpad/secrets/github-id-ed25519.age".publicKeys = rcv.all;
}
