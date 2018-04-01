%{
#include "1031449_hw4.tab.h" /* header file generated by bison */
#include <string.h>
using namespace std;
%}

%option yylineno
Digit [0-9]
IntLit {Digit}+

%%
(#.*(\n)) {}
" "   {}
[\t]  {}  
[\n]  {}

"INPUT" {
  strcpy(yylval.name , yytext);
  return inputGate;
}
"OUTPUT" {
  strcpy(yylval.name , yytext);
  return outputGate;
}
"BUFF" {
  strcpy(yylval.name , yytext);
  return buffGate;
}
"NOT" {
  strcpy(yylval.name , yytext);
  return notGate;
}
"AND" {
  strcpy(yylval.name , yytext);
  return andGate;
}
"NAND" {
  strcpy(yylval.name , yytext);
  return nandGate;
}
"OR" {
  strcpy(yylval.name , yytext);
  return orGate;
}
"XOR" {
  strcpy(yylval.name , yytext);
  return xorGate;
}
"NOR" {
  strcpy(yylval.name , yytext);
  return norGate;
}
"NXOR" {
  strcpy(yylval.name , yytext);
  return nxorGate;
}
[1-9]{IntLit}*  {

  strcpy(yylval.name , yytext);
  return VAR;  
  }
. { return yytext[0]; }
%%
int yywrap()
{
return 1;
}