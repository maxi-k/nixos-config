let
  rcv = import ../secrets/recipients.nix;
in
{
  "modules/eca/brave-api-key.age".publicKeys = rcv.all;
}
