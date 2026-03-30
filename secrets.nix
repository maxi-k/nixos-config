# Collect secrets and recipients from `secrets.nix` files in this repo
# (like from hosts and from modules) to be used with agenix for re-keying
# them etc.
let
  importIfExists = path: if builtins.pathExists path then import path else { };

  importSecretsFrom = baseDir:
    let
      entries = builtins.readDir baseDir;
      names = builtins.attrNames entries;
      secretFiles = builtins.filter (
        name: entries.${name} == "directory" && builtins.pathExists (baseDir + "/${name}/secrets.nix")
      ) names;
    in
      builtins.foldl' (
        acc: name: acc // importIfExists (baseDir + "/${name}/secrets.nix")
      ) { } secretFiles;
in
  importSecretsFrom ./modules
  // importSecretsFrom ./hosts
