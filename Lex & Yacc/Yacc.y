%{
#include <stdio.h>
#include<math.h>
#include<string.h>
extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(char *);
struct var{
	char name[100];
	double num;
};
struct var data[1000]; 
int count=0;
int j;

%}
%token <val> NUMBER
%token NEG
%token LOG
%token ABS
%token SIN
%token COS
%token INCREMENT
%token DECREMENT
%token <name> VAR

%type <val> expression var term factor group

%union {
	double val;
	char name[30];
}
%%
lines
 : /* empty */
 | lines expression '\n' { printf("%lf\n", $2); }
 | lines var '\n'{ printf("%lf\n", $2); }
 ;
var
 :VAR '=' expression {
	int i = 0;
	for(;i < count;){
		if(strcmp(data[i].name, $1)!=0){
			i++;
		}
	}
	strcpy(data[i].name, $1);
	data[i].num = $3;
	if (i == count) ++count;
	$$ = data[i].num;
 }
 | VAR expression{
	int i = 0;
	int j=0;
	for(;i < count;){
		if(strcmp(data[i].name, $1)!=0){
			i++;
		}
		if(strcmp(data[i].name, $1)==0){
		j=1;
			break;
		}
	}
	if(j==0){
		printf("Line %d: %s is undefine.\n", yylineno, $1);
		return 0;
	}
	else{
		data[i].num += $2;	
		$$=data[i].num;

	}
 }
 | expression VAR{
	int i = 0;
	int j=0;
	for(;i < count;){
		if(strcmp(data[i].name, $2)!=0){
			i++;
		}
		if(strcmp(data[i].name, $2)==0){
		j=1;
			break;
		}
	}
	if(j==0){
		printf("Line %d: %s is undefine.\n", yylineno, $2);
		return 0;
	}
	else{
		data[i].num += $1;	
		$$=data[i].num;

	}
 }
 ;
expression
 : term { $$ = $1; }
 | expression '+' term { $$ = $1 + $3; }
 | expression '-' term { $$ = $1 - $3; }
 ;
term
 : factor { $$ = $1; }
 | term '*' factor { $$ = $1 * $3; }
 | term '/' factor { $$ = $1 / $3; }
 | term '%' factor { $$ = $1 - floor($1/$3) * $3; }  
 ;
factor
 : NUMBER { $$ = $1; }
 | INCREMENT { $$ = + 1; }
 | DECREMENT { $$ = - 1; }
 | group { $$ = $1; }
 | factor '^' factor { $$ = pow($1 , $3); }
 | VAR {
	int i = 0;
	int j=0;
	for(;i < count;){
		if(strcmp(data[i].name, $1)!=0){
			i++;
		}
		if(strcmp(data[i].name, $1)==0){
		j=1;
			break;
		}
	}
	if(j==0){
		printf("Line %d: %s is undefine.\n", yylineno, $1);
		return 0;
	}
	else{
		$$=data[i].num;
	}
 }
 ;
group
 : '(' expression ')' { $$ = $2; }
 | NEG '(' expression ')' {$$ = -$3; }
 | SIN '(' expression ')' {$$ = sin($3);}
 | COS '(' expression ')' {$$ = cos($3);}
 | LOG '(' expression ')' {$$=log10($3);}
 | ABS '(' expression ')' {$$=fabs($3);}
 ;
%%
void yyerror(char *s) {
 printf("Line %d: %s with token \"%s\"\n", yylineno, s, yytext);
}
int main(void)
{
	for(j=0;j<1000;j++){
		strcmp(data[j].name," ");
		data[j].num=0;
	}
yyparse();
return 0;
}