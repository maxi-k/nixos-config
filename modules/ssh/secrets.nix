let
  recipients = import ../secrets/recipients.nix;
in
{
  "modules/ssh/ssh-config.shared.age".publicKeys = [ recipients.maxiAdmin ];
}
