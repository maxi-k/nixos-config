{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    perf
    hotspot
  ];

  hm.home.file = {
    ".local/bin/perf-record-flamegraph" = {
      source = ./perf-record-flamegraph;
      executable = true;
    };
    ".local/bin/perf-part" = {
      source = ./perf-part;
      executable = true;
    };
    ".local/bin/perf-allow" = {
      source = ./perf-allow;
      executable = true;
    };
    ".local/bin/perf-allow-nonroot" = {
      source = ./perf-allow-nonroot;
      executable = true;
    };
    ".local/bin/perf-to-flamegraph" = {
      source = ./perf-to-flamegraph;
      executable = true;
    };
  };
}
