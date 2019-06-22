

// fp16 sign[15] exponent[14:10] mantissa[9:0]
module fadd16(input [15:0] i1, input [15:0] i2, output [15:0] oz);

//4 bits are enough since is at most 10.
function [3:0] msb;
	input [11:0] a;
	integer i;
	for(i=0; i<=11; i=i+1) begin
		if(a[i]==1)begin
			msb=i;
		end
	end
endfunction



    reg [15:0] z;
    reg [15:0] a,b;
    reg a_s, b_s, z_s; //signs
    reg [5:0] a_e, b_e, z_e; //mantissas
    reg [11:0] a_m, b_m, z_m; //2 bits of for sum and carry and mantissas
    reg [5:0] delta, the_shift;


    assign oz=z;

    always@(i1 or i2)
    begin
	//a is the biggest and b is the smallest
        if(i1[14:10] > i2[14:10]) begin
	    a = i1;
	    b = i2;
	end else begin
	    if(i1[9:0] > i2[9:0]) begin
	        a = i1;
		b = i2;
	    end else begin
		a = i2;
		b = i1;
	    end
	end
	a_s = a[15]; b_s = b[15];
	a_e = a[14:10] - 15; b_e = b[14:10] - 15;
        a_m = {2'b1,a[9:0]}; b_m = {2'b1,b[9:0]};

        //if a is NaN or b is NaN return NaN 
        if ((a_e == 32 && a_m != 0) || (b_e == 32 && b_m != 0)) begin
          z_s = 1;
          z_e = 31 - 15;
          z_m[9] = 1;
          z_m[8:0] = 0;
        //if a is inf return inf
        end else if (a_e == 32) begin
          z_s = a_s;
          z_e = 31 - 15;
          z_m = 0;
          //if a is inf and signs don't match return nan
          if ((b_e == 32) && (a_s != b_s)) begin
              z_s = b_s;
              z_e = 31 - 15;
              z_m[9] = 1;
              z_m[8:0] = 0;
          end
        //if b is inf return inf
        end else if (b_e == 31) begin
          z_s = b_s;
          z_e = 31 - 15;
          z_m = 0;
        //if a is zero and b zero return zero
        end else if ((($signed(a_e) == -15) && (a_m == 0)) && (($signed(b_e) == -15) && (b_m == 0))) begin
          z_s = a_s & b_s;
          z_e = b_e[4:0] - 15;
          z_m = b_m;
        //if a is zero return b
        end else if (($signed(a_e) == -15) && (a_m == 0)) begin
          z_s = b_s;
          z_e = b_e[4:0] - 15;
          z_m = b_m;
        //if b is zero return a
        end else if (($signed(b_e) == -127) && (b_m == 0)) begin
          z_s = a_s;
          z_e = a_e[4:0] - 15;
          z_m = a_m;
	end else
	begin
	  //Put b of the same order of a
          delta = a_e - b_e;
	  b_e = b_e + delta;
          b_m = b_m >> delta;
	  //Compute the sum
	  z_s = a_s;
	  z_e = a_e;
	  z_m = a_m + (b_s == 1'b1 ? -b_m : b_m);
	  //Now normalize the result
          //Two cases. Value z_m[11:10]>1 -> just shift to right and it's done
	  if(z_m[11:10]>2'b1) begin
		z_m = z_m >> 1;
		z_e = $signed(z_e) + 1;
	  end else if(z_m[11:10]==2'b0) begin
		//Need to shift left the result
		the_shift = 10 - msb(z_m);
		z_m = z_m << the_shift;
		z_e = $signed(z_e) - the_shift;
	  end
	end
	//Now build the result
	z = {z_s,z_e[4:0]+5'd15,z_m[9:0]};
    end




endmodule
