#include <stdio.h>

int main(void)
{
	volatile int *hex5_0bus = (int*)0xFF200010; //input from bus
	
	unsigned int input = 0;
	//int proceed = 1;
 	//unsigned int temp = 0;

	while (1)
	{
		//while (proceed  == 1)
		//{
			printf("Please enter an integer (range from 0 - 4,294,967,295 or enter '1' to quit:\n");
			scanf("%u \n", input);
			
			*hex5_0bus = input;
			//temp = input;
				
			//if(temp == 1)
			//{
			//	printf("Now quitting.\n");
			//	proceed = 0;
			//}
			if (input > 4294967295)
				printf("That is not a value in 32-bit range.\n");
			else 
				printf("hex5_0bus = %u", input);
			
		
	}
	
	return 0;
	
}
