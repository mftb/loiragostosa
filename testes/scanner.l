%{
#include "parser.h" 
%}

BREAK		[\n]+
DU_HEADER 	[\\d|u[a-zA-Z0-9]+\[[a-zA-Z0-9,]+\]\{[a-z]+\}
U_HEADER	[\\d|u[a-zA-Z0-9]+\[[a-zA-Z0-9,]+\]\{[a-z]+\}
AUTHOR		[\\][a][a-z]+[{][a-zA-Z1-9 ]+[}]
ANY_CHAR 	.

%%

{BREAK}		/*IGNORE*/ ;

{DU_HEADER}	/*IGNORE*/ ;

{U_HEADER}	/*IGNORE*/ ;

{AUTHOR}	/*IGNORE*/ ;

"."		{return '.';}
"("		{return '(';}
")"		{return ')';} 
"," 	{return ',';}
";"		{return ';';}

{ANY_CHAR} {
			yylval.str = (char*) strdup(yytext);	
			return ANY_CHAR;	
}
	
%%

// Codigo C


