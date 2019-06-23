//macros for the CNN infrastructure.


/*The idea is to ALWAYS iterate with the following
* order
*
* for k in K:
*     for z in Z:
*         for X in x:
*             for Y in y:
*                 [do your thing]
*/

//Get the unique index in the 4D-matrix
`define idx(K,Z,X,Y,k,z,x,y) (Z*X*Y*k+X*Y*z+Y*x+y)

//Get bit index of a single bit in a 4D matrix
`define bitidx(K,Z,X,Y,k,z,x,y,size,offset) (size*`idx(K,Z,X,Y,k,z,x,y)+offset)

//select one single bit of w using 4d matrix indexing
`define bitsel(w,K,Z,X,Y,k,z,x,y,size,offset) w[ `bitidx(K,Z,X,Y,k,z,x,y,size,offset) ]

//Select a slice of size in w using the uppercase parameters as the sizes dimension
//and the lowercase paramets as indices 
`define slice(w,K,Z,X,Y,k,z,x,y,size) w[`bitidx(K,Z,X,Y,k,z,x,y,size,(size-1)) : `bitidx(K,Z,X,Y,k,z,x,y,size,0)]


