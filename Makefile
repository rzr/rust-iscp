delay ?= 5

all: main

main: main.rs
	rustc $<

setup: /etc/debian_version
	sudo apt-get install -y rustc

run: main
	${<D}/${<F}
cleanall:
	rm main

test/PWR: main
	${<D}/${<F} PWR00
	sleep ${delay}
	${<D}/${<F} PWR01
	sleep ${delay}
	${<D}/${<F} PWR00
	sleep ${delay}
	${<D}/${<F} PWR01


test: test/PWR
