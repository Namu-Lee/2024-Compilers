#
# File Name   : Makefile
# Description : Makefile for project #1.
# 
# Course      : Introduction to Compilers
# Dept. of Electrical and Computer Engineering, Seoul National University
#

CC = gcc
LEX = flex

CFLAGS = -g
LDFLAGS = -lfl

OBJECTS = lex.yy.o hash.o

all: subc

clean:
	rm -f lex.yy.c rm *.o subc

subc: $(OBJECTS)
	$(CC) -o subc $(OBJECTS) $(LDFLAGS)

hash.o: hash.c subc.h
	$(CC) -c $(CFLAGS) hash.c

lex.yy.o: lex.yy.c
	$(CC) -c $(CFLAGS) lex.yy.c

lex.yy.c: subc.l
	$(LEX) subc.l

