#include<iostream>
#include<vector>
#include<string>
#include "1031449_hw4.tab.h"
using namespace std;
extern int yyparse();
struct ans{
	string num;
	int value;
	string buff;
	string in[2];
	ans(){
    num = "";
    value = 2;
    buff = "";
    in[2] = {""};
  }
};
vector<ans> result;
vector<ans> hold;
vector<string> outans;
void cal(vector<ans> &result, int num,int in){
	if (result[num].buff == "NOT"){
		result[num].value = !in;
	}
	if (result[num].buff == "BUFF"){
		result[num].value = in;
	}
}
void cal2(vector<ans> &result, int num, int in,int in2){
	if (result[num].buff == "AND"){
	result[num].value = in & in2;
	}
	if (result[num].buff == "NAND"){
		result[num].value = !(in & in2);
	}
	if (result[num].buff == "OR"){
		result[num].value = in | in2;
	}
	if (result[num].buff == "NOR"){
		result[num].value = !(in | in2);
	}
	if (result[num].buff == "XOR"){
		result[num].value = in ^ in2;
	}
	if (result[num].buff == "NXOR"){
		result[num].value = !(in ^ in2);
	}
}
void answer(){

		vector<ans> check;
		check=result;
		while (!check.empty()){

			int cc = 0;
			for (int i = 0; i < result.size(); i++){

				if (check[check.size() - 1].num == result[i].num){
					if (result[i].value != 2){
						check.pop_back();
						cc++;
					}
					if (cc != 0){
						break;
					}
					if (result[i].in[1] == ""){
						for (int x = 0; x <  result.size(); x++){
							if (result[i].in[0] == result[x].num){

								if (result[x].value != 2){

									cal(result, i, result[x].value);

									check.pop_back();
									cc++;
									break;
								}
								else{
									check.push_back(result[x]);
									cc++;
									break;
								}
							}
						}
					}
					if (result[i].in[1] != ""){

						for (int x = 0; x <  result.size(); x++){

							if (result[i].in[0] == result[x].num){

								if (result[x].value != 2){
									for (int b = 0; b <  result.size(); b++){
										if (result[i].in[1] == result[b].num){
											if (result[b].value != 2){

												cal2(result, i, result[x].value, result[b].value);

												check.pop_back();
												cc++;
												break;
											}
											else{
												check.push_back(result[b]);
												cc++;
												break;
											}

										}

									}

								}
								else{

									check.push_back(result[x]);
									cc++;
									break;
								}
							}
							if (cc != 0){
								break;
							}
						}
					}
				}
				if (cc != 0){
					break;
				}
			}
		}
		for (int i = 0; i <  outans.size(); i++){
				for(int j=0;j<result.size();j++){
					if(outans[i]==result[j].num)
					cout << result[j].value;
				}
					
		}	
	}
int main(){
	yyparse();
	hold=result;
	for(int i = 0  ; i< result.size() ; i++)
	{
		if(result[i].buff=="OUTPUT"){
			outans.push_back(result[i].num);
			result.erase(result.begin()+i);
			i--;

		}
	}	
	for(int i = 0  ; i< hold.size() ; i++)
	{
		if(result[i].buff=="INPUT"){
			result[i].value=1;
		}
	}	
	answer();
	
	cout<<"\n";
	
	result=hold;
	for(int i = 0  ; i< result.size() ; i++)
	{
		if(result[i].buff=="OUTPUT"){

			result.erase(result.begin()+i);
			i--;
		}
	}	

	for(int i = 0  ; i< result.size() ; i++)
	{

		if(result[i].buff=="INPUT"){
			result[i].value=0;
		}
	}	
	answer();
	cout<<"\n";


}