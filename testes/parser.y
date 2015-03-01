%{
#include <stdio.h>

void yyerror(const char* errmsg);
void yywrap(void);

%}

%union{
	char *str;
	int intval;
}

%token <str> ANY_CHAR

%error-verbose

%%

stmt: ANY_CHAR				{ printf("%s\n", $1);}

%%

void yyerror(const char* errmsg)
{
	printf("***Error: %s\n", errmsg);
}


void yywrap(void){
	return ;
}


void main()
{
	yyparse();
	return ;
}



