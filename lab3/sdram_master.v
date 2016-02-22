module sdram_master (
input clk,
input reset_n,
input waitrequest,
input readdatavalid,
input start,
input [15:0] readdata,
output reg read_n,
output reg write_n,
output reg chipselect,
output reg [31:0] address =0,
output reg [1:0] byteenable,
output reg [15:0] writedata,
output reg done
);

reg [3:0] state;
reg [3:0] nextstate;

localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0100;
localparam S4 = 4'b1000;

//reg arrayfull;
reg [3:0] count;
reg [3:0] index;
reg [15:0] array [0:9];
reg[15:0] max, min;

reg arrayfull;
reg donesort;


initial begin
	index = 0;
	count = 0;
	byteenable = 2'b11;
	write_n = 1;
	read_n = 1;
	done = 0;
	end


// Sequential current state logic
always @(posedge clk)
begin 
   if(reset_n==0)             // synchronous active low reset signal
	   state <= S1;        // reset state is S1
	else
	   state <= nextstate; // if reset is off, go to nextstate
end


//logic for next state
always @ (*) begin
case(state)
	S1: begin
			if(!start)
				nextstate = S1;
			else 
				nextstate = S2;
		end
		
	S2:	begin
			if(arrayfull == 0)
				nextstate = S2;
			else 
				nextstate = S3;
		end
		
	S3:	begin
			if(donesort == 0)
				nextstate = S3;
			else begin
				if(waitrequest == 0)
					nextstate = S4;
				else 
					nextstate = S3;
				end
		end
		
	S4:	begin
			if(waitrequest == 1)
				nextstate = S4;
			else
				nextstate = S1;
		end
	
	default: nextstate = S1;     //default
		
endcase
end
				

//output logic
always @(posedge clk) begin
case(state)
	S1: begin
			if(!start) begin  //if start is off, no read and no write, system is doing nothing
				count <= 0;
				done <= 0;
				address <= 0;
				end
				
			else begin  // if start is on, start reading data from sdram
				read_n <= 0;
				count <= 0;
				done <= 0;
				address <= 0;
				end
		end
		
	S2: begin
			if(arrayfull == 0) begin  //if arrray is not full  //count < 10
				if(readdatavalid ==1) begin  //if readdatavalid is on, reads data and stores in the arrray
					array[count] <= readdata;
					end
				if(waitrequest == 0) begin
					count <= count +1;
					address <= address +2;
					end
				end
					
			else begin   // array is full with 10 numbers
				read_n <=1;    //turn read signal off
				index <=2;     // for comparing from the 3rd numbers in array in state S3
				if(array[0] > array[1]) begin  //compare the first and second numbers to find max and min 
					max <= array[0];
					min <= array[1];
					end
				else begin
					max <= array[1];
					min <= array[0];
					end
				end
		end
	
	S3: begin
			if(donesort == 0) begin   //index <10
				if(array[index] > max)  // compares to find max and min from the 3rd number in the array, cuz now starting value of index = 2 
					max <= array[index];
				else if(array[index] < min)
					min <= array[index];
				else begin 
					max <= max;
					min <= min;
					end
				index <= index +1;
			end
				
			else begin   // write max value back to (base_address +1)
				if(waitrequest == 0) begin 
					address <= 2;
					writedata <= max;
					write_n <= 0;
					end
				end
		end
			
	S4: begin    
			if(waitrequest == 1) begin  //if waitrequest is on , keep the control signals constant 
				address <= 2;
				writedata <= max;
				write_n <= 0;
				end
			else begin    // if waitrequest is off, write back the min value to (base_address +2) and turn the done signal on
				address <= 4;
				writedata <= min;
				write_n <= 0;
				done <= 1;
				end
		 end
	
	
endcase
end



//logic for output arrayfull signal
always @(count) begin 
  if(count == 10)                //if count =10
     arrayfull = 1;             // then arrayfull is true 
  else                        // if count < 10
     arrayfull = 0;             // then arrayfull is false
end 

//logic for done signal 
always @(index) begin
	if(index == 10)      
		donesort = 1;
	else 
		donesort = 0;
	end  
	
endmodule
	
				
			
		
			
			