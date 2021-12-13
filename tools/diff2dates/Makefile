CFLAGS = -g -Wall
PNAME  = diff2dates
LNAME  = libdiff2dates.so

all : $(PNAME).o $(LNAME)
	gcc $(CFLAGS) -o $(PNAME) main.c $(PNAME).o

$(PNAME).o :
	gcc $(CFLAGS) -fPIC -c $(PNAME).c

$(LNAME) :
	gcc -shared -o $(LNAME) $(PNAME).o

clean :
	rm $(PNAME) $(PNAME).o $(LNAME)

check : $(PNAME)
	gcc $(CFLAGS) -o tests tests.c $(PNAME).o
	./tests
	rm ./tests $(PNAME).o
