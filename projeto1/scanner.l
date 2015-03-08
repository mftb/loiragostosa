%{
#include "parser.h"
%}

BREAK [\n]
STRING [a-zA-Z0-9\.$(),/:? !-][a-zA-Z0-9\.(),/: ?!-]*
DU_HEADER 	[\\][d|u][a-zA-Z0-9]+\[[a-zA-Z0-9,]+\]\{[a-z]+\}[\n]+
U_HEADER	  [\\][d|u][a-zA-Z0-9]+[a-zA-Z0-9,]+\{[a-z]+\}[\n]+
AUTHOR		[\\][a][a-z]+[{][a-zA-Z1-9 ]+[}][\n]+
LIST_START [ ]*\\begin\{itemize\}
ITEM			 [ ]*\\item
LIST_END	 [ ]*\\end\{itemize\}
BIB_ITEM         [ ]*\\bibitem
CITE            \\cite
ANY_CHAR .
MATH \$[a-zA-Z0-9\.(),\\: ?!-]+\$
CIFRAO \\\$

%option case-insensitive

%%

{DU_HEADER}	/* ignore */ ;
{U_HEADER}	/* ignore */ ;
{AUTHOR}	/* ignore */ ;
"\\title"		{return TITLE;}
"\\begin{document}"	{return BEGIN_DOC;}
"\\end{document}"	{return END_DOC;}
"\\maketitle"	{return MAKE_TITLE;}
"\\textbf"	{return BOLD;}
"\\textit"	{return ITALIC;}
"\\begin{thebibliography}"      {return BIB_START;}
"\\end{thebibliography}"        /* ignore */ ;
{LIST_START}	{return LIST_START;}
{ITEM}	{return ITEM;}
{LIST_END}	{return LIST_END;}
"\\includegraphics"	{return PICTURE;}	
"("	{return '(';}
")"	{return ')';} 
","	{return ',';}
";"	{return ';';}
"}"	{return '}';}
"{"	{return '{';}
{CIFRAO} {return CIFRAO;}
{MATH} {
	yylval.str = (char *) strdup(yytext);
	return MATH;
}
{BIB_ITEM} {return BIB_ITEM;}
{CITE} {return CITE;}
{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}



{BREAK}	{return BREAK;}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}


