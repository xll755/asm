// C++ program that calls an Assembly procedure

//This is our HLL prococedure coded in C++. It will establish 3 variables, a,b, and c, 
//to be used in an external procedure written in assembly. The assembly procedure will
//use the variables to perform arithemtic using the quadratic formula and then 
//returns the numbers 0 or -1 from the eax register. The valid roots will be retrieved
//by memory and displayed. If it detects 0 in eax, it will display valid roots. If it detects
// -1 in eax, it will display an error message because roots are too complex.

// Lewis Green
// CPEN 3710
// 04/12/24

#include <iostream>
#include <fstream>
using namespace std;


extern "C" {int quadratic(float a, float b, float c, float* root1ptr, float* root2ptr); }

float main()
{

	float myB, myA, myC;				//variables
	float answer1, answer2;				//results
	int valid;						//valid roots or not (0 or -1)


	cout << "Please enter the values for a, b, and c for the quadratic formula\n";
	cout << "such that [(-b+/-)sqrt(b^2-4ac)]/2a \n";

	cout << "b = ";							//get input for b
	cin >> myB;

	cout << "a = ";							//get input for a
	cin >> myA;

	cout << "c = ";							//get input for c
	cin >> myC;

	valid = quadratic(myB, myA, myC, &answer1, &answer2);	//compute equation in assembly
	
	if (valid == 0) {									//if eax is 0, then continue. If -1, invalid/complex
		cout << "[(-b)+/-sqrt(b^2-4ac)]/2a = ";			//display computed answer
		cout << answer1;
		cout << "\n";
		cout << "[(-b)+/-sqrt(b^2-4ac)]/2a = ";			//display computed answer
		cout << answer2;
		cout << "\n";
	}else{											//if eax has -1, display error
		if (valid == -1)
		cout << "A negative was found under the radical, zeroes were the inputs, or the number is too complex to compute.\n"; //returned for invalid input
	}
	return (0);
}