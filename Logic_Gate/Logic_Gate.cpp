#include<iostream>
#include<vector>
#include<string>
using namespace std;
struct ans{
	string num;
	int value;
	string buff;
	string in[2];
};
void del(vector<string> &a,int n){
	for (int i = 0; i < a[n].size(); i++){
		if (a[n][i] == '='){
			return;
		}
		if (a[n][i] == '(' || a[n][i] == ')' ){
			a[n].erase(a[n].begin()+i);
			i--;
		}
		if (a[n][i] == '#'){
			a[n].clear();
		}
	}
}
void assignin(vector<string> &a, int n, vector<string> &ip){
	string in = "INPUT";
	for (int i = 0; i < in.size(); i++){
		if (a[n][i] != in[i]){
			return;
		}
	}
	a[n].erase(a[n].begin(), a[n].begin() + in.size());
	ip.push_back(a[n]);
}
void assignout(vector<string> &a, int n, vector<string> &op){
	string in = "OUTPUT";
	for (int i = 0; i < in.size(); i++){
		if (a[n][i] != in[i]){
			return;
		}
	}
	a[n].erase(a[n].begin(), a[n].begin() + in.size());
	op.push_back(a[n]);
}
void Buffer(vector<string> a, int n, ans *&result,int &num){
	//cout << num<<endl;
	if (a[n] == ""){
		return;
	}
	int i = 0;
	int count = 0;
	for (int j = 0; j < a[n].size(); j++){
		if (a[n][j] != '='){
			count++;
		}
		if (count == a[n].size()){
			return;
		}
	}
	for (; a[n][i]!='='; i++){
		result[num].num.push_back(a[n][i]);
	}
	result[num].num.erase(result[num].num.end()-1);
	i++;
	for (int j=0; a[n][i] != '(';j++, i++){
		result[num].buff.push_back(a[n][i]);
	}
	i++;
	for (int b = 0; b < a[n].size(); b++){
		if (a[n][b] == ','){
			for (int j = 0; a[n][i] != ','; j++, i++){
				result[num].in[0].push_back(a[n][i]);
			}
			break;
		}
		if (a[n][b] == ')'){
			for (int j = 0; a[n][i] != ')'; j++, i++){
				result[num].in[0].push_back(a[n][i]);
			}
			break;
		}
	}
	if (a[n][i] == ','){
		i++;
		for (int j = 0; a[n][i] != ')'; j++, i++){
			result[num].in[1].push_back(a[n][i]);

		}
		result[num].in[1].erase(result[num].in[1].begin());
	}
	num++;
}
void cal(ans *&result, int num,int in){
	if (result[num].buff == " NOT"){
		result[num].value = !in;
	}
	if (result[num].buff == " BUFF"){
		result[num].value = in;
	}
}
void cal2(ans *&result, int num, int in,int in2){
	if (result[num].buff == " AND"){
	result[num].value = in & in2;
	}
	if (result[num].buff == " NAND"){
		result[num].value = !(in & in2);
	}
	if (result[num].buff == " OR"){
		result[num].value = in | in2;
	}
	if (result[num].buff == " NOR"){
		result[num].value = !(in | in2);
	}
	if (result[num].buff == " XOR"){
		result[num].value = in ^ in2;
	}
	if (result[num].buff == " NXOR"){
		result[num].value = !(in ^ in2);
	}
}
int main(){
	int get=0;
	string in;
	vector<string> input;
	while (getline(cin,in)){
			input.push_back(in);
	}


		//cout << get << endl;

		

		vector<string> ip;
		vector<string> op;


		ans *result;
		result = new ans[input.size()];
		int num = 0;
		//cout << input.size();
		for (int i = 0; i < input.size(); i++){
			del(input, i);
			assignin(input, i, ip);
			assignout(input, i, op);
			Buffer(input, i, result, num);
			//cout << result[num].num << endl;
		}
		ans *inp;
		inp = new ans[ip.size()];
		ans *outp;
		outp = new ans[op.size()];
		for (int i = 0; i < op.size(); i++){
			outp[i].num = op[i];
		}
		for (int i = 0; i < ip.size(); i++){
			inp[i].num = ip[i];
		}
	for (; get < 2; get++){
		for (int i = 0; i < num; i++){
			result[i].value = -1;
		}
		for (int i = 0; i < ip.size(); i++){
			inp[i].value = get;
		}
		for (int i = num, j = 0; i < num + ip.size(), j < ip.size(); i++, j++){
			result[i] = inp[j];
		}
		vector<string> check;
		for (int i = 0; i < num; i++){
			check.push_back(result[i].num);
		}

		while (!check.empty()){
			int cc = 0;
			for (int i = 0; i < num + ip.size(); i++){

				if (check[check.size() - 1] == result[i].num){
					if (result[i].value != -1){
						check.pop_back();
						cc++;
					}
					if (cc != 0){
						break;
					}
					if (result[i].in[1] == ""){
						for (int x = 0; x < num + ip.size(); x++){
							if (result[i].in[0] == result[x].num){

								if (result[x].value != -1){
									cal(result, i, result[x].value);
									check.pop_back();
									cc++;
									break;
								}
								else{
									check.push_back(result[x].num);
									cc++;
									break;
								}
							}
						}
					}
					if (result[i].in[1] != ""){

						for (int x = 0; x < num + ip.size(); x++){

							if (result[i].in[0] == result[x].num){
								if (result[x].value != -1){
									for (int b = 0; b < num + ip.size(); b++){
										if (result[i].in[1] == result[b].num){
											if (result[b].value != -1){
												cal2(result, i, result[x].value, result[b].value);
												check.pop_back();
												cc++;
												break;
											}
											else{
												check.push_back(result[b].num);
												cc++;
												break;
											}

										}

									}

								}
								else{

									check.push_back(result[x].num);
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
		for (int j = 0; j < op.size(); j++){
			for (int i = 0; i < num + ip.size(); i++){
				if (op[j] == result[i].num){
					cout << result[i].value;
				}
			}
		}
		cout << endl;
	}
	
}