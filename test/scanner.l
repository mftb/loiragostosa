%{
#include "parser.h" 
%}

HEADERS	[\\][d|u][a-z]+[[][a-z]+[]][{][a-z]+[}][\n]
AUTHOR	[\\][a][a-z]+[{][a-z]+[}][\n]
ANY_CHAR [.]*

%%

{HEADERS}	{return HEADERS;}

{AUTHOR}	{return AUTHOR;}

{ANY_CHAR} {
			yylval.str = (char*) strdup(yytext);	
			return ANY_CHAR;	
}
	
%%

// Codigo C


