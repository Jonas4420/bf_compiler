.PHONY: all clean mrproper

CC      = gcc
CFLAGS  = -O3 -Wall -pedantic
LDFLAGS =

FLEX  = flex
BISON = bison

PROG  = brainfuck
SRC   = brainfuck.o brainfuck.tab.c lex.yy.c

%.c: %.y
%.c: %.l

all: $(PROG)

$(PROG): brainfuck.o brainfuck.tab.o lex.yy.o
	$(CC) $(LDFLAGS) -o $(PROG) $^

brainfuck.o: brainfuck.c
	$(CC) $(CFLAGS) -c brainfuck.c

brainfuck.tab.o: brainfuck.tab.c
	$(CC) $(CFLAGS) -c brainfuck.tab.c

brainfuck.tab.c: brainfuck.y
	$(BISON) -d brainfuck.y

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c: brainfuck.lex
	$(FLEX) -o lex.yy.c brainfuck.lex

clean:
	rm -rf brainfuck.tab.c brainfuck.tab.h lex.yy.c
	rm -rf brainfuck.dSYM
	rm -rf *.o

mrproper: clean
	rm -rf $(PROG)
