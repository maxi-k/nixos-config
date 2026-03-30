{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    perf
    hotspot
  ];

  hm = { addHomeBinary, ... }: {
    home.file = {}
      // addHomeBinary "perf-record-flamegraph" {
        source = ./perf-record-flamegraph;
        executable = true;
      }
      // addHomeBinary "perf-part" {
        source = ./perf-part;
        executable = true;
      }
      // addHomeBinary "perf-allow" {
        source = ./perf-allow;
        executable = true;
      }
      // addHomeBinary "perf-allow-nonroot" {
        source = ./perf-allow-nonroot;
        executable = true;
      }
      // addHomeBinary "perf-to-flamegraph" {
        source = ./perf-to-flamegraph;
        executable = true;
      };
  };
}
