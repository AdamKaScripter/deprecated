CFLAGS = -g -Wall
PNAME  = diff2dates

all : $(PNAME)
	gcc $(CFLAGS) -o $(PNAME) main.c $(PNAME).o

$(PNAME) :
	gcc $(CFLAGS) -c $(PNAME).c

clean :
	rm $(PNAME) $(PNAME).o

test : $(PNAME)
	gcc $(CFLAGS) -o tests tests.c $(PNAME).o
	./tests
	rm ./tests $(PNAME).o
