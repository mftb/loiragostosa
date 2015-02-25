%{
#include <stdio.h>

void yyerror(const char* errmsg);
void yywrap(void);

%}

%union{
	char *str;
	int intval;
}

%token <intval> T_DIGIT
%token <str> T_STRING

%%

stmt_list:  	stmt ';'
	 | 	stmt_list stmt ';'

stmt: T_STRING '=' T_DIGIT     { printf("%s", $1); }

%%

void yyerror(const char* errmsg)
{
	printf("***Error: %s\n", errmsg);
}


void yywrap(void){
	return 1;
}


void main()
{
	yyparse();
	return 0;
}



