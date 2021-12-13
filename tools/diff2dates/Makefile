CFLAGS = -g -Wall

all : diff2dates
	gcc $(CFLAGS) -o diff2dates main.c diff2dates.o

diff2dates :
	gcc $(CFLAGS) -c diff2dates.c

clean :
	rm diff2dates diff2dates.o
