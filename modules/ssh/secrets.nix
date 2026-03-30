let
  rcv = import ../secrets/recipients.nix;
in
{
  "modules/ssh/ssh-config.shared.age".publicKeys = rcv.all;
}
