`include "fadd16.v"
`include "fmuldiv16.v"

//Just swap the sign bit of A
module finv16(input [15:0] A, output [15:0] B);
    assign B = {~A[15],A[14:0]};
endmodule


module fsub(input [15:0] A, input [15:0] B, output[15:0] C);
    wire [15:0] minusB;

    finv16 invertB(B,minusB);
    fadd16 adder(A,minusB,C);

endmodule
