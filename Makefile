##
# Project Title
#
# @file
# @version 0.1

HOSTNAME := $(shell hostname)
TIGERWM_PATH ?= /home/maxi/dev/tigerwm
LISPWM_PATH ?= /home/maxi/dev/lispwm
TIGERWM_INPUT ?= $(if $(wildcard $(TIGERWM_PATH)/flake.nix),path:$(TIGERWM_PATH),)
LISPWM_INPUT ?= $(if $(wildcard $(LISPWM_PATH)/flake.nix),path:$(LISPWM_PATH),)
SUDO := $(if $(filter 0,$(shell id -u)),,sudo --preserve-env=HOME,SSH_AUTH_SOCK)
OVERRIDE_INPUT_ARGS := \
	$(if $(TIGERWM_INPUT),--override-input tigerwm $(TIGERWM_INPUT),) \
	$(if $(LISPWM_INPUT),--override-input lispwm $(LISPWM_INPUT),)

update-inputs:
	nix flake lock --update-input tigerwm --update-input lispwm
.PHONY: update-inputs

switch:
	$(SUDO) nixos-rebuild switch --flake .#$(HOSTNAME) --impure $(OVERRIDE_INPUT_ARGS)
.PHONY: switch

boot:
	$(SUDO) nixos-rebuild boot --flake .#$(HOSTNAME) --impure $(OVERRIDE_INPUT_ARGS)
.PHONY: boot

test:
	$(SUDO) nixos-rebuild test --flake .#$(HOSTNAME) --impure $(OVERRIDE_INPUT_ARGS)
.PHONY: test

vm:
	$(SUDO) nixos-rebuild build-vm --flake .#$(HOSTNAME) --impure $(OVERRIDE_INPUT_ARGS)
.PHONY: vm

live-usb:
	nix build .#nixosConfigurations.live-usb.config.system.build.isoImage --impure
.PHONY: live-usb

secrets-new-identity:
	mkdir -p ${HOME}/.config/agenix
	nix shell nixpkgs#age -c age-keygen -o ${HOME}/.config/agenix/keys.txt
.PHONY: secrets-new-identity

secrets-rekey:
	agenix -r -i ${HOME}/.config/agenix/keys.txt    
.PHONY: secrets-rekey


# end
