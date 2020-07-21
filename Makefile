all: main

main: main.rs
	rustc $<

setup: /etc/debian_version
	sudo apt-get install -y rustc

run: main
	${<D}/${<F}
