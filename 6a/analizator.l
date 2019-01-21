%{
/* potrzebujemy tego do wywołania atof() */
#include <math.h>
%}
DIGIT       ([0-9])|([1-9][0-9]*)
HEX         0x[0-9A-F]+
STATIC_REAL [0-9]+\.[0-9]{2}
FLOAT       [0-9]+\.[0-9]+E("+"|"-")[0-9]+
ALLOWED     [ \t]+({DIGIT}|{HEX}|{STATIC_REAL}|{FLOAT})
%%

{ALLOWED}+[\r]?[\n]* {
    printf("Rozpoznano: %s", yytext);
}

. printf( "Nierozpoznany znak: %s\n", yytext );

%%


int main( argc, argv )
int argc;
char **argv;
{
    ++argv, --argc;  /* pomiń nazwę programu */
    if ( argc > 0 ) {
        yyin = fopen( argv[0], "r" );
    } else {
        yyin = stdin;
    }
    yylex();
}


// int main() {
//     yylex();
//     return 0;
// }

int yywrap(void) {
	return 0;
}