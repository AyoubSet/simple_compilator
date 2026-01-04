%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+(\.[0-9]+)?   { yylval.num = atof(yytext); return NUMBER; }

"sum"       { return SUM; }
"product"   { return PRODUCT; }
"average"   { return AVERAGE; }
"variance"  { return VARIANCE; }
"ecartype"  { return ECARTYPE; }



"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MUL; }
"/"     { return DIV; }
"("     { return LPAREN; }
")"     { return RPAREN; }
","     { return COMMA; }

\n      { return '\n'; }
[ \t]+  { }

.       { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
