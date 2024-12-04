/*
 * File Name    : subc.h
 * Description  : A header file for the subc program.
 * 
 * Course       : Introduction to Compilers
 * Dept. of Electrical and Computer Engineering, Seoul National University
 */

#ifndef __SUBC_H__
#define __SUBC_H__

#include <stdio.h>
#include <strings.h>

typedef struct id {
  int tokenType;
  char *name;
  int count;
} id;

// Hash table interfaces
unsigned hash(char *name);
id *enter(int tokenType, char *name, int length);

#endif