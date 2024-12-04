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
#include "subc.tab.h"
static int comment_depth = 0;
static int lineno = 1;
%}

/* Definitions Section */
/* This section contains simple name definitions and declarations of start conditions. */

letter        [A-Za-z_]
digit         [0-9]
id            {letter}({letter}|{digit})*
integer_const ([1-9]{digit}*)|"0"
whitespace    [ \t]
special_char  \\[nt]

%x COMMENT

%%

  /* Rules Section */
  /* This section contains series of rules for recognizing tokens. */
  /* All comments in this section must be indented. */

  /* Keywords */
"int" | "char"                  { return TYPE; }
"struct"                        { return STRUCT; }

  /* Identifiers */
{id}                            {
                                  struct id *entered  = enter(ID, yytext, yyleng);
                                  yylval.stringVal = entered->name;
                                  return entered->tokenType;
                                }

  /* Integer constants */
{integer_const}                 {
                                  yylval.intVal = atoi(yytext);
                                  return INTEGER_CONST;
                                }

  /* String variables */
\"({special_char}|[^\\\"\n])*\" {
                                  yylval.stringVal = yytext;
                                  return STRING;
                                }

  /* Character variables */
'({special_char}|[^\\'\n])'     {    
                                  yylval.stringVal = yytext;
                                  return CHAR_CONST;
                                }

  /* Operators */
","                             { return ','; }
";"                             { return yytext[0]; }

  /* Whitespaces */
{whitespace}


  /* Comment blocks */
<INITIAL,COMMENT>"/*"           {
                                  ++comment_depth;
                                  BEGIN (COMMENT);
                                }
<COMMENT>"*/"                   { 
                                  if(--comment_depth == 0) 
                                    BEGIN (INITIAL);
                                }
<COMMENT>.

  /* Tracking line numbers */
<*>\n                           { ++lineno; }

%%
   
/* User Code Section */
/* The user code section is simply copied to lex.yy.c verbatim. */

int get_lineno() {
  return lineno;
}

int main(int argc, char* argv[]) {
  // Define reserved keywords
  char *keyword[] = { "int", NULL };
  int tokentype[] = { TYPE, 0 };

  // Initialize the hash table
  for(int i=0; keyword[i] != NULL; i++) {
    enter(tokentype[i], keyword[i], strlen(keyword[i]));
  }

  // I/O stream settings
  if (argc >= 2) {
    yyin = fopen(argv[1], "r");
  } else {
    yyin = stdin;
  }

  if(!yyin) {
    printf("Can't open input stream!\n");
    exit(1);
  }
  
  yyparse();
  fclose(yyin);
  
  return 0;
}
