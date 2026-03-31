let
  rcv = import ../secrets/recipients.nix;
in
{
  "modules/ssh/secrets/ssh-config.shared.age".publicKeys = rcv.all;
  "modules/ssh/secrets/github.age".publicKeys = rcv.all;
  "modules/ssh/secrets/id_rsa.age".publicKeys = rcv.all;
  "modules/ssh/secrets/tum.age".publicKeys = rcv.all;
}
