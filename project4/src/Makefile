#
# File Name   : Makefile
# Description : Makefile for the compilers project.
# 
# Course      : Introduction to Compilers
# Dept. of Electrical and Computer Engineering, Seoul National University
#

LEX = flex

YACC = bison
YFLAGS = -d

CC = gcc
CFLAGS = -g
LDFLAGS = -lfl

# Modify here if there are additional source files.
OBJECTS = subc.tab.o lex.yy.o hash.o

all: subc

subc: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o subc

lex.yy.o: lex.yy.c subc.tab.h

subc.tab.o: subc.tab.c

lex.yy.c: subc.l
	$(LEX) $(LFLAGS) subc.l

subc.tab.h subc.tab.c: subc.y
	$(YACC) $(YFLAGS) subc.y

clean: 
	rm -f *.o subc.tab.h subc.tab.c lex.yy.c subc