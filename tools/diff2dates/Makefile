CC     = gcc
CFLAGS = -g -Wall
PNAME  = diff2dates
LNAME  = libdiff2dates.so

build :
	$(CC) $(CFLAGS) -fPIC -c $(PNAME).c
	$(CC) -shared -o $(LNAME) $(PNAME).o
	$(CC) $(CFLAGS) -o $(PNAME) main.c $(PNAME).o

clean :
	rm $(PNAME) $(PNAME).o $(LNAME)

check :
	$(CC) $(CFLAGS) -fPIC -c $(PNAME).c
	$(CC) $(CFLAGS) -o tests tests.c $(PNAME).o
	./tests
	rm ./tests $(PNAME).o
