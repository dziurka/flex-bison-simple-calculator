%{
#include <math.h>
#include <stdio.h>
#include "y.tab.h"
%}
DEC [ \t]+[1-9]+[0-9]*
HEX [ \t]+0x[0-9A-F]+
STATIC_REAL [ \t]+[0-9]+\.[0-9]{2}
FLOAT_REAL [ \t]+[0-9]+\.[0-9]+E("+"|"-")[0-9]+
%%

{DEC} {
    yylval.i=atoi(yytext);
    printf("Liczba całkowita\n");
    return DEC;
}

{HEX} {
    int number = (int)strtol(yytext, NULL, 16);
    yylval.i=number;
    printf("Liczba heksadecymalna\n");
    return HEX;
}

{STATIC_REAL} {
    yylval.f = atof(yytext);
    printf("Liczba stałoprzecinkowa\n");
    return STATIC_REAL;
}
{FLOAT_REAL} {
    yylval.f = atof(yytext);
    printf("Liczba zmiennoprzecinkowa\n");
    return FLOAT_REAL;
}
[\r]?[\n] {
    printf("Znak nowej linii\n");
    return NL;
}

. {
    printf("Nieznany znak\n");
    return U;
}

%%


