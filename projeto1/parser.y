%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

char *concat(int count, ...);
char title[1000];
int refs;
int cite;

%}
 
%union{
	char *str;
	int  *intval;
}

%token <str> T_STRING TITLE BEGIN_DOC END_DOC MAKE_TITLE BOLD ITALIC LIST_START ITEM LIST_END PICTURE BREAK CIFRAO MATH BIB_ITEM BIB_START CITE

%type <str> phrase

%start stmt_list

%error-verbose
 
%%

stmt_list: 	stmt_list stmt 
	 |	stmt 
;

stmt:
	  BEGIN_DOC BREAK {printf("<body>\n");}
	| END_DOC BREAK {printf("</body>\n");}
	|	MAKE_TITLE BREAK {printf("<h1>%s</h1>\n",title);}
	| TITLE '{' T_STRING '}' BREAK {strcpy(title,$3);}
	| BOLD '{' T_STRING '}' BREAK {printf("<b>%s</b>\n",$3);}
	| ITALIC '{' T_STRING '}' BREAK {printf("<i>%s</i>\n",$3);}
	| LIST_START BREAK {printf("<ul>\n");}
	| ITEM T_STRING BREAK {printf("<li>%s</li>\n",$2);}
	| ITEM '[' T_STRING ']' T_STRING BREAK {printf("<br><b>%s</b> %s\n",$3,$5);}
	| LIST_END BREAK {printf("</ul>\n");} 
	| BREAK {printf("<br>\n");}
	| phrase BREAK {printf("%s\n",$1);}
        | BIB_START BREAK {printf("<h2>References</h2><br>\n");}
        | BIB_ITEM '{' T_STRING '}' T_STRING BREAK{printf("<br><span id=%d name=\"%s\">[%d]</span>%s\n",refs++,$3,refs,$5);}
;

phrase:   phrase CIFRAO 					{$$ = concat(2,$1,"$");}
        | phrase PICTURE '{' T_STRING '}'                       {$$ = concat(4,$1,"<img src=\"",$4,"\">\n");}
	| phrase T_STRING					{$$ = concat(2,$1,$2);}
        | phrase MATH						{$$ = concat(4,$1,"(",$2,")");}
        | phrase CITE '{' T_STRING '}'		{$$ = concat(4,$1,"<span id=\"",$4,"\"></span>");}
	| T_STRING						{$$ = $1;}
        | CIFRAO						{$$ = "$";}
        | MATH							{$$ = concat(3,"(",$1,")");}
        | PICTURE '{' T_STRING '}'                              {$$ = concat(3,"<img src=\"",$3,"\">\n");}
        | CITE '{' T_STRING '}'                                 {$$ = concat(3,"<span id=\"",$3,"\"></span>");}
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
                 refs = 0;
		 printf("<html>\n");
		 printf("<head>\n");
		 printf("<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js\"></script>");
		 printf("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n");
		 printf("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n");
     printf("<script type=\"text/x-mathjax-config\">\n");
		 printf("MathJax.Hub.Config({tex2jax: {inlineMath: [[\"($\",\"$)\"]]}});\n");
		 printf("</script>\n");
     printf("<script type=\"text/javascript\" src=\"https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\">\n");
  	 printf("</script>\n");
		 printf("<script>\n");
		 printf("$( document ).ready(function() {\n");
		 printf("var i = 0;\nvar name = $('#0').attr('name');\n");
		 printf("while(name != null){\n");
		 printf("$('[id=\"' + name + '\"]').text(\"[\" + i + \"]\");\ni++;\n");
		 printf("name = $('#' + i).attr('name');\n");
		 printf("}\n});\n</script>\n");
		 printf("</head>\n");
     yyparse();
 		 printf("</html>\n");
     return 0;
}


