
module top(A, B, SUM);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] SUM;  
wire [8:0] tmp; 
 
  assign tmp = A + B;  
  assign SUM = tmp [7:0];  
endmodule
