

module fmul16(
	a,b,
	output_z);

  //4 bits are enough since is at most 11.
  function [3:0] msb;
    input [10:0] a;
    integer i;
    for(i=0; i<=10; i=i+1) begin
        if(a[i]==1)begin
            msb=i;
        end
    end
  endfunction


  input     [15:0] a;
  input     [15:0] b;

  output    [15:0] output_z;

  reg       [15:0] z;
  reg       [10:0] a_m, b_m, z_m;
  reg       [21:0] result;
  reg       [6:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, old_guard, round_bit, sticky;
  reg       [21:0] product;
  reg       normalize;

  assign output_z = z;

  always @*
  begin
    a_s = a[15]; b_s = b[15];
    a_e = a[14:10]-15; b_e = b[14:10]-15;
    a_m = {1'b1,a[9:0]}; b_m = {1'b1,b[9:0]};


    //handle special cases before
    
    //Compute multiplication
    z_s = a_s ^ b_s;
    z_e = a_e + b_e;
    product = a_m * b_m;
    //For sure there are 20 decimal digits, so for sure we have a 1 in the
    //range of [21:20]
    case( product[21:20] ) 
      2'b00:
	//THIS SHOULD NOT HAPPEN!
        normalize=0;
      2'b10:
      	normalize=1;
      2'b01:
      	normalize=0;
      2'b11:
      	normalize=1;
    endcase
    z_e = z_e + normalize;
    z_m = product >> (10+normalize);
    
    z = {z_s,z_e[4:0]+5'hf,z_m[9:0]};

  end

endmodule
