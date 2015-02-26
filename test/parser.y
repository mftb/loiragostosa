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
%token <str> HEADERS
%token <str> AUTHOR

%error-verbose

%%

stmt: ANY_CHAR			{ printf("%s", $1);	}
stmt: HEADERS				{ printf("HEADERS IGNORADO\n");	}
stmt: AUTHOR				{ printf("AUTHOR IGNORADO\n");	}

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



