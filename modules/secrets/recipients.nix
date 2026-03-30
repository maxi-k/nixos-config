let
  thinkpad = "age14thjdmw5jqwu367fa7sdkp22ja2edj6uv4w2v77grevlarg2xyqqzfxgtj";
  luna = "age16av395mvm799asr3leu9cadsse8ccxqxrdffzyaknzxneh8d2qmssdw0d6";
in
{
  all = [thinkpad luna];
  thinkpad = thinkpad;
  luna = luna;
}
