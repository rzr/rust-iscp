#!/bin/make -f

project?=iscp
delay ?= 1
exe_src ?= src/main.rs
exe ?= target/debug/${project}

HOST ?= am335x-opt.local:60128
export HOST

all: ${exe}

${exe}: cargo/build

make/${exe}: ${exe}.rs
	rustc -o $@ $<

setup: /etc/debian_version
	sudo apt-get install -y rustc 
	sudo apt-get install -y elpa-rust-mode

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

run: cargo/run


doc:
	cargo doc --open
