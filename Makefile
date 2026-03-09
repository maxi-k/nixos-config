##
# Project Title
#
# @file
# @version 0.1

switch:
	nixos-rebuild switch --flake .#$(shell hostname)
.PHONY: switch


# end
