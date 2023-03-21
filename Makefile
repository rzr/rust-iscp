#!/bin/make -f

project = iscp
url = https://github.com/rzr/rust-iscp
delay ?= 1
exe_src ?= src/main.rs
exe ?= target/debug/${project}
host ?= am335x-opt.local
port ?= 60128
sudo ?= sudo

all: ${exe}

${exe}:
	ls ${exe} || ${MAKE} cargo/build
	stat $@

exe: ${exe}
	stat $<

make/${exe}: ${exe}.rs
	rustc -o $@ $<

setup: /etc/debian_version
	${sudo} apt-get install -y cargo

setup/devel: setup version
	${sudo} apt-get install -y elpa-rust-mode

/etc/debian_version:
	@echo "error: Only ${@F} is supported"
	@echo "error: Please submit ticket to ${url}"

make/run: ${exe}
	${<D}/${<F}

cleanall:
	rm ${exe}

AMT/% \
DIM/% \
MVL/% \
PWR/% \
SLI/% \
: ${exe}
	sleep ${delay}
	cargo run ${@D}${@F}
	sleep ${delay}

test/PWR:
	${MAKE} ${@F}/00
	${MAKE} ${@F}/01
	${MAKE} ${@F}/00
	${MAKE} ${@F}/01

test: test/PWR test/MVL

test/MVL/%:
	sleep ${delay}
	${<D}/${<F} MVL${@F}
	sleep ${delay}

test/MVL:
	${MAKE} ${@F}/00
	${MAKE} ${@F}/99
	${MAKE} ${@F}/42
	${MAKE} ${@F}/UP
	${MAKE} ${@F}/DOWN

test/DIM:
	${MAKE} ${@F}/00
	${MAKE} ${@F}/01
	${MAKE} ${@F}/02
	${MAKE} ${@F}/03
	${MAKE} ${@F}/00

test/AMT:
	${MAKE} ${@F}/00
	${MAKE} ${@F}/01
	${MAKE} ${@F}/00

test/SLI:
	${MAKE} ${@F}/01
	${MAKE} ${@F}/02
	${MAKE} ${@F}/03
	${MAKE} ${@F}/10
	${MAKE} ${@F}/11
	${MAKE} ${@F}/12
	${MAKE} ${@F}/22
	${MAKE} ${@F}/23
	${MAKE} ${@F}/24
	${MAKE} ${@F}/25
	${MAKE} ${@F}/26
	${MAKE} ${@F}/29
	${MAKE} ${@F}/2B
	${MAKE} ${@F}/2E
	${MAKE} ${@F}/55
	${MAKE} ${@F}/56
	${MAKE} ${@F}/57


cargo/%:
	${@D} ${@F}

LICENSE: /usr/share/common-licenses/MPL-2.0
	cp -v $< $@

version:
	make --version
	rustc --version
	cargo --version

release:
	${MAKE} cargo/check
	${MAKE} cargo/build
	cargo build --release

run: exe check cargo/run

doc:
	cargo doc --open

check:
	-ping -c 1 ${host}

setup/debian/nix:
	${sudo} apt-get install -y nix-bin
	${sudo} adduser ${USER} nix-users
	groups | grep nix-users || echo "sudo -E su -l ${USER}"
	@echo "source /usr/share/doc/nix-bin/examples/nix-profile.sh"

nix:
	nix --version
	nix-env --version
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	nix-channel --update
	nix-env -iA nixpkgs.cargo

flake.nix: Cargo.lock
	nix --extra-experimental-features 'nix-command flakes' flake init -t templates#rust

Cargo.lock: Cargo.toml
	cargo update

nix/run:
	nix --extra-experimental-features 'nix-command flakes' ${@F}

nix-env:
	nix-env -iA 
