/*
* Right-To-Left Binary Exponentiation
* This code implements a naive left-to-right
* Modular exponentiation as explained in:
*
* The pseudo-code is the following:
* def modexp_lr(a, b, n):
    r = 1
    for bit in reversed(_bits_of_n(b)):
        r = r * r % n
        if bit == 1:
            r = r * a % n
    return r 

   The body of the loop is implemented using
   The innerPow module while the loop is unrolled
   inside modPow
*/

module innerPow #(parameter IDX=0) (base,exp,modulus,cur_res,result,base_out);
    input [7:0] base, exp,modulus, cur_res;
    output [7:0] base_out, result;
    wire [7:0] b2;
    assign b2 = base % modulus;
    assign result = (exp[IDX] == 1'b1) ? ( (cur_res*b2) % modulus) : cur_res;
    assign base_out = (b2*b2) % modulus;
endmodule


module modPow(a,b,n,out);
    input [7:0] a,b,n;
    output [7:0] out;
    wire [7:0] r0, r1, r2, r3, r4, r5, r6;
    wire [7:0] b0, b1, b2, b3, b4, b5, b6;
    innerPow #(0) p0(a ,b,n,8'b1,r0,b0);
    innerPow #(1) p1(b0,b,n,r0,r1,b1);
    innerPow #(2) p2(b1,b,n,r1,r2,b2);
    innerPow #(3) p3(b2,b,n,r2,r3,b3);
    innerPow #(4) p4(b3,b,n,r3,r4,b4);
    innerPow #(5) p5(b4,b,n,r4,r5,b5);
    innerPow #(6) p6(b5,b,n,r5,r6,b6);
    innerPow #(7) p7(b6,b,n,r6,out,_unused_);
endmodule



module top(A, B,N, RES);  
input  [7:0] A;  
input  [7:0] B;  
input  [7:0] N;  
output [7:0] RES;  
 
  modPow mp0(A,B,N,RES);  
endmodule
