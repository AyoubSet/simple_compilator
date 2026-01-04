%code requires {
    typedef struct {
        double values[64];
        int count;
    } param_list;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);

double calc_sum(double*, int);
double calc_product(double*, int);
double calc_average(double*, int);
double calc_variance(double*, int);
double calc_ecartype(double*, int);

%}

%union {
    double num;
    param_list params;
}

%token <num> NUMBER
%token PLUS MINUS MUL DIV
%token LPAREN RPAREN COMMA
%token SUM PRODUCT AVERAGE VARIANCE ECARTYPE
%token UMINUS
%token END 0

%type <num> expr
%type <num> sum_call product_call average_call variance_call ecartype_call
%type <params> params

%left PLUS MINUS
%left MUL DIV
%right UMINUS

%%

input:
      
    | input statement
    ;

statement:
      '\n'
    | expr '\n' { printf("Result = %g\n", $1); }
    | expr END  { printf("Result = %g\n", $1); }
    ;

expr:
      NUMBER
    | expr PLUS expr      { $$ = $1 + $3; }
    | expr MINUS expr     { $$ = $1 - $3; }
    | expr MUL expr       { $$ = $1 * $3; }
    | expr DIV expr {
          if ($3 == 0) {
              fprintf(stderr, "Error: division by zero\n");
              YYABORT;
          }
          $$ = $1 / $3;
      }
    | LPAREN expr RPAREN  { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | sum_call
    | product_call
    | average_call
    | variance_call
    | ecartype_call
    ;

params:
      expr {
          $$.values[0] = $1;
          $$.count = 1;
      }
    | params COMMA expr {
          $$ = $1;
          $$.values[$$.count++] = $3;
      }
    | error {
          fprintf(stderr, "Syntax error: missing expression after '('\n");
          yyerrok;
          YYABORT;
      }
    | params COMMA error {
          fprintf(stderr, "Syntax error: missing expression after ','\n");
          yyerrok;
          YYABORT;
      }
    ;


sum_call:
      SUM LPAREN params RPAREN {
          $$ = calc_sum($3.values, $3.count);
      }
    | SUM error {
          fprintf(stderr, "Syntax error: missing '('\n");
          yyerrok;
          YYABORT;
      }
    | SUM LPAREN params error {
          fprintf(stderr, "Syntax error: missing ')'\n");
          yyerrok;
          YYABORT;
      }
    ;

product_call:
      PRODUCT LPAREN params RPAREN {
          $$ = calc_product($3.values, $3.count);
      }
    | PRODUCT error {
          fprintf(stderr, "Syntax error: missing '('\n");
          yyerrok;
          YYABORT;
      }
    | PRODUCT LPAREN params error {
          fprintf(stderr, "Syntax error: missing ')'\n");
          yyerrok;
          YYABORT;
      }
    ;

average_call:
      AVERAGE LPAREN params RPAREN {
          $$ = calc_average($3.values, $3.count);
      }
    | AVERAGE error {
          fprintf(stderr, "Syntax error: missing '('\n");
          yyerrok;
          YYABORT;
      }
    | AVERAGE LPAREN params error {
          fprintf(stderr, "Syntax error: missing ')'\n");
          yyerrok;
          YYABORT;
      }
    ;

variance_call:
      VARIANCE LPAREN params RPAREN {
          $$ = calc_variance($3.values, $3.count);
      }
    | VARIANCE error {
          fprintf(stderr, "Syntax error: missing '('\n");
          yyerrok;
          YYABORT;
      }
    | VARIANCE LPAREN params error {
          fprintf(stderr, "Syntax error: missing ')'\n");
          yyerrok;
          YYABORT;
      }
    ;

ecartype_call:
      ECARTYPE LPAREN params RPAREN {
          $$ = calc_ecartype($3.values, $3.count);
      }
    | ECARTYPE error {
          fprintf(stderr, "Syntax error: missing '('\n");
          yyerrok;
          YYABORT;
      }
    | ECARTYPE LPAREN params error {
          fprintf(stderr, "Syntax error: missing ')'\n");
          yyerrok;
          YYABORT;
      }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}


double calc_sum(double* v, int n) {
    double s = 0;
    for (int i = 0; i < n; i++) s += v[i];
    return s;
}

double calc_product(double* v, int n) {
    double p = 1;
    for (int i = 0; i < n; i++) p *= v[i];
    return p;
}

double calc_average(double* v, int n) {
    return calc_sum(v, n) / n;
}

double calc_variance(double* v, int n) {
    double m = calc_average(v, n), s = 0;
    for (int i = 0; i < n; i++)
        s += (v[i] - m) * (v[i] - m);
    return s / n;
}

double calc_ecartype(double* v, int n) {
    return sqrt(calc_variance(v, n));
}

