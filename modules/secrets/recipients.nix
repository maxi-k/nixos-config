let
  thinkpad = "age14thjdmw5jqwu367fa7sdkp22ja2edj6uv4w2v77grevlarg2xyqqzfxgtj";
  luna = "age16av395mvm799asr3leu9cadsse8ccxqxrdffzyaknzxneh8d2qmssdw0d6";
  jupyter = "age1pzffuhv963sgqswxlsn5nchx90azutw2pp4wt58tcqt5hqlm04dq3yy7qc";
in
{
  all = [thinkpad luna jupyter];
  thinkpad = thinkpad;
  luna = luna;
  jupyter = jupyter;
}
