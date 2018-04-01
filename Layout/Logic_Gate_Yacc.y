%{
#include <stdio.h>
#include<math.h>
using namespace std;
#include <vector>
#include <string>
extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(char *);

struct ans{
	string num;
	int value;
	string buff;
	string in[2];
};

extern vector<ans> result;
%}
%union {
	double val;
	char name[30];
}
%type<name> group
%type<name> groups
%token<name> inputGate
%token<name> outputGate
%token<name> buffGate
%token<name> notGate
%token<name> andGate
%token<name> nandGate
%token<name> orGate
%token<name> norGate
%token<name> xorGate
%token<name> nxorGate
%token<val> NUMBER
%token<name> VAR



%%
groups: groups group {}
| group{}
;

group: '('VAR')'{}
| inputGate '(' VAR ')' {
	result.push_back(ans{$3,2,$1,{"",""}});

  }
| outputGate '(' VAR ')' {
    result.push_back(ans{$3,2,$1,{"",""}});
  }
| VAR '=' buffGate '(' VAR ')' {
	result.push_back(ans{$1,2,$3,{$5,""}});
}
| VAR '=' notGate '(' VAR ')' {
	result.push_back(ans{$1,2,$3,{$5,""}});
}
| VAR '=' andGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
  
}
| VAR '=' nandGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
}
| VAR '=' orGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
}
| VAR '=' norGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
}
| VAR '=' xorGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
}
| VAR '=' nxorGate '(' VAR ',' VAR ')' {
  result.push_back(ans{$1,2,$3,{$5,$7}});
}
;


%%
void yyerror(char *s) {
 printf("Line %d: %s with token \"%s\"\n", yylineno, s, yytext);
}
