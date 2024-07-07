%{
#include <cstdlib>
#include <string>
#include "y.tab.h"
%}

%%

[a-zA-Z][a-zA-Z0-9]*    { yylval.str = new std::string(yytext);  return ID; }
[0-9]+                  { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"="                     { return '='; }
[ \t]                   ;  // skip whitespace
\n                      ;  // skip newlines
.                       { printf("Unexpected character: %s\n", yytext); exit(1); }  // Manejo de caracteres no reconocidos

%%

int yywrap() {
    return 1;
}
