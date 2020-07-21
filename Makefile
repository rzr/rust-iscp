delay ?= 1
exe ?= main

all: ${exe}

main: main.rs
	rustc $<

setup: /etc/debian_version
	sudo apt-get install -y rustc

run: main
	${<D}/${<F}
cleanall:
	rm main

PWR/%: ${exe}
	sleep ${delay}
	${<D}/${<F} ${@D}${@F}
	sleep ${delay}

DIM/%: ${exe}
	sleep ${delay}
	${<D}/${<F} ${@D}${@F}
	sleep ${delay}

AMT/%: ${exe}
	sleep ${delay}
	${<D}/${<F} ${@D}${@F}
	sleep ${delay}

test/PWR:
	${MAKE} PWR/00
	${MAKE} PWR/01
	${MAKE} PWR/00
	${MAKE} PWR/01

test: test/PWR test/MVL

test/MVL/%: main
	sleep ${delay}
	${<D}/${<F} MVL${@F}
	sleep ${delay}

test/MVL: main
	make test/MVL/00
	make test/MVL/99
	make test/MVL/42

test/DIM:
	${MAKE} DIM/00
	${MAKE} DIM/01
	${MAKE} DIM/02
	${MAKE} DIM/03
	${MAKE} DIM/00

test/AMT:
	${MAKE} ${@F}/00
	${MAKE} ${@F}/01
	${MAKE} ${@F}/00
