CC=gcc
AR=ar
CFLAGS=-Wall -Iinclude
ARFLAGS=rcs
SRC=$(wildcard src/*.c)
BUILD=$(patsubst src/%.c, build/%.o, $(SRC))

app:build/main.o build/libdemo.a
	$(CC) $^ -o $@
build/libdemo.a:build/log.o build/util.o
	$(AR) $(ARFLAGS) $@ $^
build/%.o:src/%.c | build
	$(CC) $(CFLAGS) -c $< -o $@


build:
	mkdir -p ./build
clean:
	rm -rf ./build 

.PHONY:clean
