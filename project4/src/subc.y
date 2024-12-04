/*
 * File Name    : subc.y
 * Description  : a skeleton bison input
 * 
 * Course       : Introduction to Compilers
 * Dept. of Electrical and Computer Engineering, Seoul National University
 */

%{
/* Prologue section */
#include "subc.h"

int   yylex();
int   yyerror(char* s);
int   get_lineno();
char* yyget_text();
void  reduce(char* s);
%}

/* Bison declarations section */

/* yylval types */
%union {
  int   intVal;
  char  *stringVal;
}

/* Precedences and Associativities */
%left ','
%left STRUCTOP

/* Tokens and Types */
%token            TYPE STRUCT
%token<stringVal> ID CHAR_CONST STRING
%token<intVal>    INTEGER_CONST

%%

/* Grammar rules section*/
program
  : ext_def_list
  {
    reduce("program->ext_def_list");
  }
  ;

ext_def_list
  : ext_def_list ext_def
  {
    reduce("ext_def_list->ext_def_list ext_def");
  }
  | %empty 
  {
    reduce("ext_def_list->epsilon");
  }
  ;

unary
  : INTEGER_CONST
  {
    reduce("unary->INTEGER_CONST");
  }
  | CHAR_CONST
  {
    reduce("unary->CHAR_CONST");
  }
  | STRING
  {
    reduce("unary->STRING");
  }
  | ID
  {
    reduce("unary->ID");
  }
  ;

%%

/* Epilogue section */

int yyerror (char* s) {
  fprintf (stderr, "yyerror: %s at line %d, token '%s'\n", s, get_lineno(), yyget_text());
}

void reduce(char* s) {
  printf("%s\n",s);
}