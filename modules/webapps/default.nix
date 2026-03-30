{ config, lib, pkgs, ... }:

let
  cfg = config.repo.webapps;
  webappScript = pkgs.writeShellScript "webapp" ''
    url=$1; shift || true
    if [ -z "$url" ]; then
        echo "usage: $0 <url>"
        exit 1
    fi

    case "$url" in
        https://*) ;;
        *) url="https://$url" ;;
    esac

    exec ${lib.getExe cfg.browserPackage} --app="$url" "$@"
  '';
  webSearchScript = pkgs.writeShellScript "web-search" ''
    query=$1; shift || true
    if [ -z "$query" ]; then
      echo "usage: $0 <query>"
      exit 1
    fi

    query=$(printf '%s' "$query" | sed 's/ /%20/g')
    exec ${lib.getExe cfg.browserPackage} "https://search.brave.com/search?q=$query" "$@"
  '';
in
{
  options.repo.webapps.browserPackage = lib.mkOption {
    type = lib.types.package;
    default = pkgs.brave;
    description = "Browser package used for webapp wrappers.";
  };

  config = {
    environment.systemPackages = [ cfg.browserPackage ];

    hm = { addHomeBinary, ... }: {
      home.file = {}
        // addHomeBinary "webapp" {
          source = webappScript;
          executable = true;
        }
        // addHomeBinary "web-search" {
          source = webSearchScript;
          executable = true;
        }
        // addHomeBinary "chatgpt-scratchpad" {
          source = ./chatgpt-scratchpad;
          executable = true;
        };
    };
  };
}
