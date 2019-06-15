/*
 Python pseudo-code:
def exp(a,b):
    r = 1
    for bit in reversed(_bits_of_n(b)):
        r *= r
        if bit == 1:
            r *= a
    return r
*/


// This is very similar to regular sequential code
module exp #(parameter WIDTH=8)(base,exp,result);
	input [WIDTH-1:0] base, exp;
	output[WIDTH-1:0] result;
	wire [WIDTH-1:0] tmp = WIDTH'b1; 

	integer i;

	always @* begin
	for(i=WIDTH-1;i>=0;i = i-1)begin
		tmp = tmp * tmp * (exp[i]==1'b1 ? base : WIDTH'b1);	
	end
		result = tmp;
	end
	
endmodule

module top(A, B, RES);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] RES;  
 
  exp #(8) exp0(A,B,RES);  
endmodule
