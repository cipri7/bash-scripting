CC = gcc
CFLAGS = -Wall

all: script_2

script_2: script_2.c
	$(CC) $(CFLAGS) -o script_2 script_2.c

clean:
	rm -f script_2

.PHONY: clean
