%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>


void yyerror(const char *s);
int yylex(void); 

std::map<std::string, int> symbolTable;
%}

%union {
    int num;
    std::string* str;
}

%token <num> NUMBER
%token <str> ID

%type <num> expression

%left '+' '-'
%left '*' '/'

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    assignment
    | expression
    ;

assignment:
    ID '=' expression {
        symbolTable[*$1] = $3;
        printf("%s = %d\n", $1->c_str(), $3);
        delete $1;
    }
    ;

expression:
    NUMBER {
        $$ = $1;
    }
    | ID {
        if (symbolTable.find(*$1) != symbolTable.end()) {
            $$ = symbolTable[*$1];
        } else {
            yyerror("Undefined variable");
            $$ = 0;
        }
        delete $1;
    }
    | expression '+' expression {
        $$ = $1 + $3;
    }
    | expression '-' expression {
        $$ = $1 - $3;
    }
    | expression '*' expression {
        $$ = $1 * $3;
    }
    | expression '/' expression {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

%%

int main(void) {
    do {
        yyparse();
    } while (!feof(stdin));  // Leer hasta el fin de la entrada
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
