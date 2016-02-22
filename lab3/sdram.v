module sdram_master (
input clk,
input reset_n,
input waitrequest,
input readdatavalid,
input [15:0] readdata,
output reg read_n = 1,
output reg write_n = 1,
output reg chipselect,
output reg [31:0] address =0,
output reg [1:0] byteenable,
output reg [15:0] writedata
);

reg arrayfull = 0;
reg done_sort = 0;
reg [15:0] stored_array [0:9];

always @( posedge clk )    //synchronous reset signal  
	begin
		if(!reset_n) begin                 
			read_n <= 1;
			write_n <= 1;
			end
		else begin
			if(arrayfull ==0)   //if array is not full with 10 elements
				read_n <= 0;    //continue reading from slave  
			else 
				read_n <= 1;    //if array is full, turn off read request signal 
		
			if(done_sort ==0)   // if array soring is not done
				write_n <= 1;   // turn off write request 
			else 
				write_n <= 0;   //if done sorting, turn write request on to write back results
			end
	end

integer index = 0;
	
always @ (posedge clk)	  //if new data is read 
	begin
		if(readdatavalid) begin
		stored_array[index] <=  readdata;  //store new data into array 
		index <= index +1;
		end		
	end
	

/*always @(stored_array[9])  //when new data is stored in the array //index<10
	begin
		 //check to see if we have all 10 numbers in the array
			arrayfull = 1;  
	end */
always @(index)
begin
	if(index<10)
		arrayfull = 0;
	else 
		arrayfull =1;
end
	
	
///////////////////////////////////////////////////////////////////////////////////////////////
//      USE BUBBLE SORT ALGORITHM TO SORT ARRAY IN DESCENDING ORDER
///////////////////////////////////////////////////////////////////////////////////////////////
/*
parameter n = 10;
integer i, j;
reg [15:0] swap;
	
always @ (arrayfull)
	begin
		if(arrrayfull ==1) 
		begin
			for (i = 0 ; i < ( n - 1 ); i++)
				begin 
					for (j = 0 ; j < n - i - 1; j++)
					begin 
						if (stored_array[j] > stored_array[j+1]) 
							begin 
							swap <= stored_array[j];
							stored_array[j] <= stored_array[j+1];
							stored_array[j+1] <= swap;
						    end
					end 			
			    end
		end  

		if(i >= (n-1))	     //for-loop is done executed
			done_sort = 1;  
	end	
		*/
/////////////////////////////////////////////////////////////////////////////////////////////////	
//THIS IS A SECOND WAY TO SORT THE ARRAY. 
//WHAT DO YOU THINK, DUY? WHICH ONE IS BETTER?
/////////////////////////////////////////////////////////////////////////////////////////////////
 
 
reg [15:0] max = 0;
reg [15:0] min =0;
reg start_loop =0;
integer k;	
always @ (arrayfull)
	begin
		if(arrayfull ==1) 
		 begin
			if(stored_array[0] > stored_array[1]) begin
				max <= stored_array[0];
				min <= stored_array[1];
				start_loop <= 1;
				end
			else begin 
				max <= stored_array[1];
				min <= stored_array[0];
				start_loop <= 1;
				end
			
			if(start_loop ==1) begin
				for (k=2; k<10;k= k+1)
					begin 
						 if (stored_array[k] > max) 
							max <= stored_array[k];
						 else if (stored_array[k] < min)
							min <= stored_array[k];
					end 
				end
				
			if(k == 10)  //for-loop is done executed 
				done_sort = 1;

		 end
	end
/////////////////////////////////////////////////////////////////////////////////////////////////

reg [15:0] maxmin [0:1];

integer m=0;
always @(posedge clk)	
	begin
		maxmin[0] <= max;
		maxmin[1] <= min;
		if(done_sort ==1 & m<2) begin
			m <= m+1;
			address <= address +1;
			#2;
			writedata <= 2;//maxmin[m-1];  
			end
	end
	
endmodule	