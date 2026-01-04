#include <stdio.h>

int yyparse(void);
int main() {
    printf("Enter expressions:\n");
    yyparse();
    return 0;
}
