%{
#include <stdio.h>
int yywrap();
void yyerror(char* string);
int yylex();
%}

%union {
	int i;
	float f;
}

%start file
%token <i> DEC HEX INDEX
%token <f> STATIC_REAL FLOAT_REAL
%token NL U

%type <i> dec hex
%type <f> static_real float_real

%%
file    : line
        | file line
        ;
line    : INDEX dec NL          { printf("Suma l. całkowitych (wers %d) - %d \n", $1, $2); }
        | INDEX hex NL            { printf("Suma l. heksadecymalnych (wers %d) - %#x \n", $1, $2); }
        | INDEX static_real NL    { printf("Suma l. stałoprzecinkowych (wers %d) -  %f \n", $1, $2); }
        | INDEX float_real NL          { printf("Suma l. zmiennoprzecinkowych (wers %d) - %E \n", $1, $2); }
        | NL
        ;
float_real   : FLOAT_REAL {$$ = $1;}
            | float_real FLOAT_REAL {$$ = $1+$2;}
            ;
static_real : STATIC_REAL {$$ = $1;}
            | static_real STATIC_REAL {$$ = $1 + $2;}
            ;
hex     : HEX {$$ = $1;}
        | hex HEX {$$ = $1 + $2;}
        ;
dec     : DEC {$$ = $1;}
        | dec DEC {$$ = $1 + $2;}
        ;
%%
int yywrap() {
	return 0;
}
int yylex();
void yyerror(char* str) {
	printf("%s", str);
}

int main()
{
    yyparse();
    return 0;
}