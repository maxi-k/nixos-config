##
# Project Title
#
# @file
# @version 0.1

switch:
	nixos-rebuild switch --flake .#$(shell hostname)
.PHONY: switch

test:
	nixos-rebuild test --flake .#$(shell hostname)
.PHONY: switch

vm:
	nixos-rebuild build-vm --flake .#$(shell hostname)
.PHONY: vm

# end
