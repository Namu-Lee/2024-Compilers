/*                                                                          */
/* File Name    : subc.l                                                    */
/* Description  : a skeleton flex input                                     */
/*                                                                          */
/* Course       : Introduction to Compilers                                 */
/* Dept. of Electrical and Computer Engineering, Seoul National University  */
/*                                                                          */

%{

/* C Code Section */
/* Any code placed inside the brackets will be literally copied into the generated C file. */

#include "subc.h"
int commentdepth=0;

%}

/* Definitions Section */
/* This section contains simple name definitions and declarations of start conditions. */

letter  [A-Za-z_]
%start  AA BB

%%

  /* Rules Section */
  /* This section contains series of rules for recognizing tokens. */

{letter}  { }

%%

/* User Code Section */
/* The user code section is simply copied to lex.yy.c verbatim. */

void initHash() 
{
  int i;

  char* keyWord[]={
    "int","return", "\0"
  };

  // Initialize Hash Table with Keywords
  for (i = 0; strcmp(keyWord[i], "\0") !=0; i++) {
    // enter(KEYWORD, keyWord[i],strlen(keyWord[i]));
  }
}

int main(int argc, char** argv)
{
  id* temp;

  ++argv;
  --argc;

  if (argc > 0) {
    yyin = fopen(argv[0], "r");
  } else {
    yyin = stdin;
  }

  initHash();

  BEGIN AA;
  yylex ();

  return 0;
}
