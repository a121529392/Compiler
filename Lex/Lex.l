
%{
/* some initial C programs */
#include <string.h>
#define ILLEGAL 0 
#define IDNAME 1  
#define INTEGER 2 
#define FLOAT 4
#define REAL 4 
#define STRING 5
#define COMMA 6
#define SEMICOLONSYM 7
#define LEFT 8
#define RIGHT 9
#define BEGINSYM 10
#define END 11
#define READ 12
#define WRITE 13
#define IF 14
#define THEN 15
#define ELSE 16
#define ENDIF 17
#define FOR 18
#define TO 19
#define ENDFOR 20
#define WHILE 21
#define ENDWHILE 22
#define REPEAT 10
#define REPEATEND 10
#define DECLARE 25
#define AS 26
#define INTEGER2 27
#define REAL3 28
#define BOOL 29
#define SCANEOF 30
#define ASSIGNSYM 31
#define Addition 32
#define SUB 33
#define MUL 34
#define DIV 35
#define NOTEQUAL 36
#define GREATER 37
#define LESS 38
#define GREATEROREQUAL 39
#define LESSOREQUAL 40
#define EQUAL 41
#define INCREMENT 42
#define DECREMENT 43
#define REMAINDER 44
#define LAND 45
#define LOR 46
#define LNOT 49
#define CADDASSIGNMENT 50
#define CSUBASSIGNMENT 51
#define CMULASSIGNMENT 52
#define CDIVASSIGNMENT 53
#define CREMAINDERASSIGNMENT 54
int mylineno=1;
%} 
/* regular definitions */
Digit [0-9]
Letter [a-zA-Z]
IntLit {Digit}+
Id {Letter}({Letter}|{Digit}|_)*
%%
[\n] ++mylineno;
\%\%[^\n]*\n {line();}
\{\%[^\%\}]*\%\} {line();}
[ \t\n]              {/* skip white spaces */}
[Bb][Ee][Gg][Ii][Nn] {return(BEGINSYM);}
[Ee][Nn][Dd] {return(END);}
[Rr][Ee][Aa][Dd] {return(READ);}
[Dd][Ee][Cc][Ll][Aa][Rr][Ee] {return(DECLARE);}
[We][Rr][Ii][Tt][Ee] {return(WRITE);}
[Ii][Ff] {return(IF);}
[Tt][Hh][Ee][Nn] {return(THEN);}
[Ee][Ll][Ss][Ee] {return(ELSE);}
[Ee][Nn][Dd][Ii][Ff] {return(ENDIF);}
[Ff][Oo][Rr] {return(FOR);}
[Tt][Oo] {return(TO);}
[Ee][Nn][Dd][Ff][Oo][Rr] {return(ENDFOR);}
[Ww][Hh][Ii][Ll][Ee] {return(WHILE);}
[Ee][Nn][Dd][Ww][Hh][Ii][Ll][Ee] {return(ENDWHILE);}
[Rr][Ee][Pp][Ee][Aa][Tt] {return(REPEAT);}
[Rr][Ee][Pp][Ee][Aa][Tt][Ee][Nn][Dd] {return(REPEATEND);}
[Aa][Ss] {return(AS);}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr] {return(INTEGER2);}
[Rr][Ee][Aa][Ll] {return(REAL3);}
[Bb][Oo][Oo][Ll] {return(BOOL);}
<<EOF>> {return(SCANEOF);}
[1-9]{IntLit}*             {return(INTEGER);}
{Digit}             {return(INTEGER);}
{IntLit}{Id} {return(ILLEGAL);}
{Id} {return(IDNAME);}
[a-zA-Z]/"..""."*          {return(IDNAME);}
"."+ {return(ILLEGAL);}
({IntLit}[.]{IntLit})([Ee][+-]?{IntLit}) {return(REAL);}
({IntLit}[.]{IntLit})([Ee][+-]?([0-9]*[a-zA-Z]+)+) {return(ILLEGAL);}
({IntLit}[.]{IntLit}) {return(FLOAT);}
([0-9]*[a-zA-Z]*)+[.]([0-9]*[a-zA-Z]*[^[:punct:]]*)+ {return(ILLEGAL);}
\"[^\"\n]*\" {stripquotes(); return(STRING);}
\"[^\"\n]* {return(ILLEGAL);}
","","+          {return(ILLEGAL);}

","          {return(COMMA);}
";"          {return(SEMICOLONSYM);}
"("          {return(LEFT);}
")"          {return(RIGHT);}
":="/[^[:punct:]]         	 {return(ASSIGNSYM);}
"+"/({IntLit}|{Letter})          {return(Addition);}
"-"/({IntLit}|{Letter})           {return(SUB);}
"*"/({IntLit}|{Letter})           {return(MUL);}
"/"/({IntLit}|{Letter})           {return(DIV);}
"!="/({IntLit}|{Letter})          {return(NOTEQUAL);}
">"/({IntLit}|{Letter})           {return(GREATER);}
">"/({IntLit}|{Letter})           {return(GREATER);}
"<"/({IntLit}|{Letter})           {return(LESS);}
">="/({IntLit}|{Letter})          {return(GREATEROREQUAL);}
"<="/({IntLit}|{Letter})          {return(LESSOREQUAL);}
"=="/({IntLit}|{Letter})          {return(EQUAL);}
"++"/({IntLit}|{Letter})          {return(INCREMENT);}
"--"/({IntLit}|{Letter})          {return(DECREMENT);}
"%"/({IntLit}|{Letter})           {return(REMAINDER);}
"&&"/({IntLit}|{Letter})          {return(LAND);}
"||"/({IntLit}|{Letter})          {return(LOR);}
"!"/({IntLit}|{Letter})           {return(LNOT);}
"+="/({IntLit}|{Letter})          {return(CADDASSIGNMENT);}
"-="/({IntLit}|{Letter})          {return(CSUBASSIGNMENT);}
"*="/({IntLit}|{Letter})          {return(CMULASSIGNMENT);}
"/="/({IntLit}|{Letter})          {return(CDIVASSIGNMENT);}
"%="/({IntLit}|{Letter})          {return(CREMAINDERASSIGNMENT);}
":="[[:punct:]]+         	 {return(ILLEGAL);}
"*"[[:punct:]]+         	 {return(ILLEGAL);}
"+"[[:punct:]]+         	 {return(ILLEGAL);}
"-"[[:punct:]]+         	 {return(ILLEGAL);}
">"[[:punct:]]+         	 {return(ILLEGAL);}
"/"[[:punct:]]+         	 {return(ILLEGAL);}
[[:punct:]]">"				 {return(ILLEGAL);}
.  			 {return (ILLEGAL);}
%%
/* some final C programs */
stripquotes(){
  int frompos,topos=0,numquotes=2;
  for(frompos=1;frompos<yyleng;frompos++){
    yytext[topos++]=yytext[frompos];
  }
  yyleng -= numquotes;
  yytext[yyleng]='\0';
}
line(){
  int i;
  for(i=0;i<yyleng;i++){
    if(yytext[i]=='\n'){
		++mylineno;
	}
  }
}

void main(){
  int i,j;
  i = yylex();
  char token[100]={'\0'};
  int count=0;
  while (i>-1) {
	if(i==30){
		printf("Token number:%d,value:SCANEOF,line%d\n",i,mylineno);
		break;
	}
	
	else if(i==0){
		strcat(token,yytext);
		count++;
		
	}
	else if(i!=0&&count!=0){
		printf("line %d: %s is an illegal identifier \n",mylineno,token);
		for(j=0;j<100;j++){
			token[j]='\0';
		}
		count=0;
		printf("Token number:%d,value:\"%s\",line%d\n",i,yytext,mylineno);
	}
	else{
	printf("Token number:%d,value:\"%s\",line%d\n",i,yytext,mylineno);
	}
    i = yylex(); 
  }

}