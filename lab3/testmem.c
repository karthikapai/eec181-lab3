#include <stdio.h>
#include <ctype.h>


int main(void) {
	// RAM 00;
	//volatile int * hex		 		=(int *) 0xFF200000;
	//volatile int *Hex0_Hex5 = (int*)0xFF200028;
	//volatile int *hex_led 	=(int *) 0xFF200028;
	
	volatile int * address = (int *)0xC4000000;

	unsigned int input = 0;
	unsigned int valid_in = 0;
	int quit;
	int count =0;
	//int size = 100;
	static int array[100];
	//*(Hex0_Hex5) = 0; // innitialize hex and led display
	
	while(1) 
	{
		printf("Enter an integer: ");
		scanf("%u", &input);
	
		if (input <0 || input > 4294967295) 
		{
			printf("Please input a valid number that fits 32-bits number \n");
			continue;
		}
        
		else
			valid_in = input;
			
		// Load into to_hex_to_led register
		*(address) = valid_in;
		address = address +1;
		array[count] = valid_in;
		count = count + 1;
		printf("Do you want to quit? Yes = 1, No = 0: ");
		scanf("%d", &quit);
		if (quit == 1)
		{
			printf("Cya.\n");
			break;
		}
		else 
		{ 
			continue;
		}
		
		
	}
	
	printf("count is %d\n", count);
	address = 0xC4000000;
	int readdata;
	int i;
	int valid;
	for (i=0; i< count; i++)
	{
		readdata = *(address + i);
		if (array[i] == readdata)
			valid = 1;
		else 
			valid = 0;
		
		if (valid == 0)
			printf("invalid data", readdata);
		
		
	}
	
	return 0;
}
