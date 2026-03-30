let
  recipients = import ../secrets/recipients.nix;
in
{
  "modules/eca/brave-api-key.age".publicKeys = [ recipients.maxiAdmin ];
}
