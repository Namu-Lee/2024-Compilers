/*
 * File Name    : hash.c
 * Description  : An implementation file for the hash table.
 * 
 * Course       : Introduction to Compilers
 * Dept. of Electrical and Computer Engineering, Seoul National University
 */

#include "subc.h"

#define  HASH_TABLE_SIZE   101

typedef struct nlist {
  struct nlist *next;
  id *data;
} nlist;

static nlist *hashTable[HASH_TABLE_SIZE];

id *enter(int tokenType, char *name, int length) {
  // TODO: Implement this function
}
