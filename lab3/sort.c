#include <stdio.h>
#include <ctype.h>

int main(void)
{
	int i = 0;
	int quit;
	
	volatile int *address = (int*) 0xC4000000;
	volatile int *start = (int*) 0xFF200020 ;
	volatile int *done = (int*) 0xFF200010 ; 
	
	unsigned int input = 0;
	unsigned int valid_in = 0;
	
	// initial array inputs
	while (i < 10)
	{
		printf("Enter an integer: ");
		scanf("%u", &input);
	
		if (input <0 || input > 65535) 
		{
			printf("Please input a valid number that fits 16-bits number \n");
			continue;
		}
		else
		{
			valid_in = input;
		}

		*(address) = valid_in;
		address = address + 1;
		
		i++;
		//if(i==1)
		//	*(start) = 1;
		
	}
	if(i==10)
		*(start) = 1;
	
	while (1) // now waiting for the done signal to ask users enter another array or quit the program
	{

		if(*(done) == 1)
			{
				address = 0xC4000000;
				printf("Do you want to continue? yes = 1, no = 0 : ");
				scanf("%d", &quit);
				
				if (quit == 0)
				{
					printf("bye\n");
					break;
				}
				else
				{
					i = 0;
					// input another array
					while (i < 10)
					{
						printf("Enter an integer: ");
						scanf("%u", &input);
					
						if (input <0 || input > 65535) 
						{
							printf("Please input a valid number that fits 16-bits number \n");
							continue;
						}
						else
						{
							valid_in = input;
						}


						*(address) = valid_in;
						address = address +1;
						i++;
						
					}
				}	
				
			}
	}
		
}