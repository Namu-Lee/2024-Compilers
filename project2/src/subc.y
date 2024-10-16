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

int   yylex ();
int   yyerror (char* s);
void  REDUCE(char* s);

%}

/* Bison declarations section */

/* yylval types */
%union {
  int		intVal;
  char	*stringVal;
}

/* Precedences and Associativities */
%left ','
%left STRUCTOP

/* Tokens and Types */
%token 				    TYPE STRUCT
%token<stringVal>	ID CHAR_CONST STRING
%token<intVal>		INTEGER_CONST

%%

/* Grammar rules section*/
program
  : ext_def_list
  {
    REDUCE("program->ext_def_list");
  }
  ;

ext_def_list
  : ext_def_list ext_def
  {
    REDUCE("ext_def_list->ext_def_list ext_def");
  }
  | %empty 
  {
    REDUCE("ext_def_list->epsilon");
  }
  ;

unary
  : INTEGER_CONST
  {
    REDUCE("unary->INTEGER_CONST");
  }
  | CHAR_CONST
  {
    REDUCE("unary->CHAR_CONST");
  }
  | STRING
  {
    REDUCE("unary->STRING");
  }
  | ID
  {
    REDUCE("unary->ID");
  }
  ;

%%

/* Epilogue section */

int yyerror (char* s)
{
  fprintf (stderr, "%s\n", s);
}

void REDUCE( char* s)
{
  printf("%s\n",s);
}
