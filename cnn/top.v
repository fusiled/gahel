`include "layers/relu.v"

//Dimensions
`define NC 1
`define X 2
`define Y 2
`define Z 1


module top(input [16*`NC*`X*`Y*`Z-1:0] in, output [16*`NC*`X*`Y*`Z-1:0] out);

    relu #(`NC,`X,`Y,`Z) the_relu(in,out);

endmodule
