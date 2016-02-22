#include <stdio.h>
#include <stdlib.h>
#include <time.h>


/*
int main(void)
 {
	 int array[1000];
	 int * address = (int *)0xC4000000;   // fpga on-chip memory
	 
	 int i = 0;
	int fakeCounter = 0;
	initCounters ()
		
	// RAM 00;
	//volatile int * sdram		 		=(int *) 0xC4000000;
	//volatile int * hex_led 			=(int *) 0xFF200028;
	
	//while(1) 
	//{
//		clock_t diff, readtime;
	//	clock_t start, end;
		
	//	int i=0;
		while(i<1000)
		{
			array[i]= 1;
			i++;
		}
		//start = clock(); //start
		int count=0;
		while(count<1000)
		{
			*(address) =array[count];
			*(address) =*(address) +4;
			count++;
		}
		
		unsigned int time = getCycles();
		for (i = 0; i < 20000; i++)
fakeCounter = fakeCounter + 1;
time = getCycles() - time;
printf ("Elapsed Time: %d cycles\n", time);
time = getCycles();
		//end = clock();
		//diff = (end-start)/CLOCKS_PER_SEC;
		//printf("write time");
		//printf("%d\n", diff);
		
	/*	start = clock(); //start
		int y = 0;
		while(y<1000)
		{
			array[y]=*(address);
			*(address) =*(address) -4;
			y++;
		}
		end = clock();
		readtime = (end-start)/CLOCKS_PER_SEC;
		
		int n=0;
		while(n<8000)
		{
			//output= *(sdram[n]);
			printf("%d\n", array[n]);
			n++;
		}
		//readtime = (clock()-end)/CLOCKS_PER_SEC;
		printf("Read time");
		printf("%d\n", readtime); 
	//}
	return 0;
 }*/
	
static inline unsigned int getCycles ()
{
	unsigned int cycleCount;
 // Read CCNT register
	asm volatile ("MRC p15, 0, %0, c9, c13, 0\t\n": "=r"(cycleCount));
	return cycleCount;
}

static inline void initCounters ()
{
 // Enable user access to performance counter
	asm volatile ("MCR p15, 0, %0, C9, C14, 0\t\n" :: "r"(1));
 // Reset all counters to zero
	int MCRP15ResetAll = 23;
	asm volatile ("MCR p15, 0, %0, c9, c12, 0\t\n" :: "r"(MCRP15ResetAll));
 // Enable all counters:
	asm volatile ("MCR p15, 0, %0, c9, c12, 1\t\n" :: "r"(0x8000000f));
 // Disable counter interrupts
	asm volatile ("MCR p15, 0, %0, C9, C14, 2\t\n" :: "r"(0x8000000f));
 // Clear overflows:
	asm volatile ("MCR p15, 0, %0, c9, c12, 3\t\n" :: "r"(0x8000000f));
}

int main(void)
{
	int array[8000];
	volatile int * address = (int *)0xC4000000;   // fpga on-chip memory
	 
	int i = 0;
	int fakeCounter = 0;
	initCounters ();

	while(i<8000)
	{
		array[i]= 1;
		i++;
	}
	
	int count;

	unsigned int time = getCycles();
	for (count = 0; count < 8000; count++)
	{
		*(address) =array[count];
		*(address) =*(address) +4;
		fakeCounter = fakeCounter + 1;
	}

	time = getCycles() - time;
	printf ("Write Time: %d cycles\n", time);

	int j;	
	time = getCycles();	
	for ( j= 0; j < 8000; j++)
	{
		array[7999 - j] = *(address);
		*(address) = *(address) -4;
		fakeCounter = fakeCounter + 1;
	}
	time = getCycles() - time;
	printf ("Read Time: %d cycles\n", time);
	printf("The stored data is: %d", *(address));

}

	
