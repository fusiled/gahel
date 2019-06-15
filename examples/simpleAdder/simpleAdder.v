//Add, Sub, Mul and Div are built-in
//Be aware of the overflows/underflows that may happen
module top(A, B, SUM);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] SUM;  
 
  assign SUM = A + B;  
endmodule
