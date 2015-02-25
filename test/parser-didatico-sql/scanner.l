%{
#include "parser.h"
%}

STRING [a-z][a-z0-9_]*
WHITESPACE [ \n\r\t]+
ANY_CHAR .

%option case-insensitive

%%

{WHITESPACE} /* ignore */ ;
"SELECT" 	{return T_SELECT;}
"FROM" 		{return T_FROM; }
"CREATE"	{return T_CREATE;}
"TABLE"		{return T_TABLE;}
"INSERT"	{return T_INSERT;}
"INTO"		{return T_INTO;}
"VALUES"	{return T_VALUES;}
"("		{return '(';}
")"		{return ')';} 
"," 		{return ',';}
";"		{return ';';}


{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}


