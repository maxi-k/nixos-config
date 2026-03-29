##
# Project Title
#
# @file
# @version 0.1

update-inputs:
	nix flake lock --update-input tigerwm 
.PHONY: update-inputs

switch: update-inputs
	nixos-rebuild switch --flake .#$(shell hostname)
.PHONY: switch

test: update-inputs
	nixos-rebuild test --flake .#$(shell hostname)
.PHONY: switch

vm: update-inputs
	nixos-rebuild build-vm --flake .#$(shell hostname)
.PHONY: vm

live-usb: update-inputs
	nix build .#nixosConfigurations.live-usb.config.system.build.isoImage --impure
.PHONY: vm

# end
