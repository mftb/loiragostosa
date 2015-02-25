%{
#include "parser.h" 
%}

WHITESPACE [ \n\r\t]+
STRING [a-zA-Z]+
HEADERS [\\][d|u]{STRING}
ANY_CHAR .

%%

{HEADERS}	/*IGNORE*/ ;

{WHITESPACE}	{
			yylval.str = (char*) strdup(yytext);
			return WHITESPACE;
		}

{STRING}	{
			yylval.str = (char*) strdup(yytext);	
			return T_STRING;
		}

{ANY_CHAR} 	{
			/*printf("Caracter %c (ASCII %d) inesperado.\n", yytext[0], yytext[0]);*/
			yylval.str = (char*) strdup(yytext);
			return ANY_CHAR
		}
	
%%

// Codigo C


