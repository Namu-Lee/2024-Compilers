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
  int   intVal;
  char  *stringVal;
}

/* Precedences and Associativities */
%left   ','
%right  '='
%left   LOGICAL_OR
%left   LOGICAL_AND
%left   EQUOP
%left   RELOP
%left   '+' '-'
%left   '*' '/' '%'
%right  '!' '&' INCOP DECOP
%left   '[' ']' '(' ')' '.' STRUCTOP

%precedence IF
%precedence ELSE

%type program ext_def_list ext_def type_specifier struct_specifier func_decl param_list param_decl def_list def compound_stmt stmt_list stmt expr_e expr binary unary args pointers
%token ID TYPE STRUCT RETURN WHILE FOR BREAK CONTINUE CHAR_CONST STRING SYM_NULL
%token<intVal> INTEGER_CONST

/* Grammar rules */
%%
program
  : ext_def_list
  ;

ext_def_list
  : ext_def_list ext_def
  | %empty
  ;

ext_def
  : type_specifier pointers ID ';'
  | type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  | func_decl compound_stmt
  ;

type_specifier
  : TYPE
  | struct_specifier
  ;

struct_specifier
  : STRUCT ID '{' def_list '}'
  | STRUCT ID
  ;

func_decl
  : type_specifier pointers ID '(' ')'
  | type_specifier pointers ID '(' param_list ')'
  ;

pointers
  : '*'
  | %empty
  ;

/* list of formal parameter declaration */
param_list  
  : param_decl
  | param_list ',' param_decl
  ;		

 /* formal parameter declaration */
param_decl 
  : type_specifier pointers ID
  | type_specifier pointers ID '[' INTEGER_CONST ']'
  ;

/* list of definitions, definition can be type(struct), variable, function */
def_list    
  : def_list def
  | %empty
  ;

def
  : type_specifier pointers ID ';'
  | type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ;

/* compound statement with local definitions */
compound_stmt
  : '{' def_list stmt_list '}'
  ;

stmt_list
  : stmt_list stmt
  | %empty
  ;

stmt
  : expr ';'
  | compound_stmt
  | RETURN ';'
  | RETURN expr ';'
  | ';'
  | IF '(' expr ')' stmt
  | IF '(' expr ')' stmt ELSE stmt
  | WHILE '(' expr ')' stmt
  | FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  | BREAK ';'
  | CONTINUE ';'
  ;

expr_e
  : expr
  | %empty
  ;

expr
  : unary '=' expr
  | binary
  ;

binary
  : binary RELOP binary
  | binary EQUOP binary
  | binary '+' binary
  | binary '-' binary
  | binary '*' binary
  | binary '/' binary
  | binary '%' binary
  | unary %prec '='
  | binary LOGICAL_AND binary
  | binary LOGICAL_OR binary
  ;

unary
  : '(' expr ')'
  | '(' unary ')'
  | INTEGER_CONST
  | CHAR_CONST
  | STRING 
  | ID
  | '-' unary %prec '!'
  | '!' unary
  | unary INCOP %prec STRUCTOP
  | unary DECOP %prec STRUCTOP
  | INCOP unary %prec '!'
  | DECOP unary %prec '!'
  | '&' unary
  | '*' unary %prec '!'
  | unary '[' expr ']'
  | unary '.' ID
  | unary STRUCTOP ID
  | unary '(' args ')'
  | unary '(' ')'
  | SYM_NULL
  ;

 /* actual parameters(function arguments) transferred to function */
args
  : expr
  | args ',' expr
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
