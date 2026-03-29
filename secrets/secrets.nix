let
  maxiAdmin = "age14thjdmw5jqwu367fa7sdkp22ja2edj6uv4w2v77grevlarg2xyqqzfxgtj";
in
{
  "shared/ssh-config.age".publicKeys = [ maxiAdmin ];
  "hosts/thinkpad-maxi/ssh-config.local.age".publicKeys = [ maxiAdmin ];
  "hosts/thinkpad-maxi/github-id-ed25519.age".publicKeys = [ maxiAdmin ];
}
