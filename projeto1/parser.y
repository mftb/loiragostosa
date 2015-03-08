%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

char *concat(int count, ...);
char title[1000];

%}
 
%union{
	char *str;
	int  *intval;
}

%token <str> T_STRING TITLE BEGIN_DOC END_DOC MAKE_TITLE BOLD ITALIC LIST_START ITEM LIST_END PICTURE BREAK CIFRAO MATH

%type <str> phrase

%start stmt_list

%error-verbose
 
%%

stmt_list: 	stmt_list stmt 
	 |	stmt 
;

stmt:
		BEGIN_DOC BREAK {printf("<body onload=\"myFunction()\">\n");}
	| END_DOC BREAK {printf("</body>\n");}
	|	MAKE_TITLE BREAK {printf("<h1>%s</h1>\n",title);}
	| TITLE '{' T_STRING '}' BREAK {strcpy(title,$3);}
	| BOLD '{' T_STRING '}' BREAK {printf("<b>%s</b>\n",$3);}
	| ITALIC '{' T_STRING '}' BREAK {printf("<i>%s</i>\n",$3);}
	| LIST_START BREAK {printf("<ul>\n");}
	| ITEM T_STRING BREAK {printf("<li>%s</li>\n",$2);}
	| LIST_END BREAK {printf("</ul>\n");} 
	| PICTURE '{' T_STRING '}' BREAK {printf("<img src=\"%s\">\n",$3);}
	| BREAK {printf("<br>\n");}
	| phrase BREAK {printf("%s\n",$1);}
;

phrase: phrase CIFRAO 					{$$ = concat(2,$1,"$");}
	| phrase T_STRING							{$$ = concat(2,$1,$2);}
  | phrase MATH									{$$ = concat(4,$1,"(",$2,")");}
	| T_STRING										{$$ = $1;}
  | CIFRAO											{$$ = "$";}
  | MATH												{$$ = concat(3,"(",$1,")");}
%%
 
char* concat(int count, ...)
{
    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)
    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}


int yyerror(const char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
		 printf("<html>\n");
		 printf("<head>\n");
		 printf("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>");
		 printf("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n");
		 printf("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n");
     printf("<script type=\"text/x-mathjax-config\">\n");
		 printf("MathJax.Hub.Config({tex2jax: {inlineMath: [[\"($\",\"$)\"]]}});\n");
		 printf("</script>\n");
     printf("<script type=\"text/javascript\" src=\"https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\">\n");
  	 printf("</script>\n");
		 printf("</head>\n");
     yyparse();
 		 printf("</html>\n");
     return 0;
}


