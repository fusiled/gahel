`include "cnn/macro.v"

/*
* To call a macro, remember to add the backtick ` before the name of the
* macro, then it is like a function. 
	*/

(* nomem2reg *)
module relu #(parameter NUM_CHANNELS=1,parameter X_SIZE=1,parameter Y_SIZE=1,parameter Z_SIZE=1)(data_in,data_out);

    input[16*NUM_CHANNELS*X_SIZE*Y_SIZE*Z_SIZE-1:0] data_in;
    output[16*NUM_CHANNELS*X_SIZE*Y_SIZE*Z_SIZE-1:0] data_out;

    integer k,z,i,j;
    always @* begin
	for(k=0;k<NUM_CHANNELS;k=k+1)begin
		for(z=0;z<Z_SIZE;z=z+1)begin
			for(i=0;i<X_SIZE;i=i+1)begin
				for(j=0;j<Y_SIZE;j=j+1)begin
					`slice(data_out,NUM_CHANNELS,Z_SIZE,X_SIZE,Y_SIZE,k,z,i,j,16) = 
						(`bitsel(data_in,NUM_CHANNELS,Z_SIZE,X_SIZE,Y_SIZE,k,z,i,j,16,15)==0) 
						? `slice(data_in,NUM_CHANNELS,Z_SIZE,X_SIZE,Y_SIZE,k,z,i,j,16) 
						: 0;
				end
			end
		end			
	end

    end //end always block
endmodule
