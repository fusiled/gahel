# GAHEL : GAte Homomorphic Encryption Library


GAHEL is able to perform **ANY** kind of homomorphic operation. It combines
the Verilog programming language to produce a gate-list that uses homomorphic
encryption to perform computation over encrypted data in a gate-level style.
This infrastrcture allow to write any kind of program without having to re-engineer
the system. For further details see the `documentation` folder 

## Quickstart
To setup GAHEL:
```
git clone <something>
cd gahel
#This will build a docker image end enter in it
bash launch.sh
#This will build what gahel needs
su <your-username>
bash support/setup_gahel.sh
```

You can re-enter in the docker container re-running `bash launch.sh`.
The container will be resumed.

To run an 8-bit adder with 3 and 5 as input we can use an example (from the 
container environment):
```
# Copy the example folder in the workspace
cp /gahel/examples/simpleAdder /gahel/workspace/
cd /gahel/workspace/simpleAdder
# Let's generate a key-pair
keygen
# Let's use the generated keys to  encrypt 3 and
#  5 with secret.key contained in the folder
encrypt8 3 cipher3.tfhe secret.key
encrypt8 5 cipher5.tfhe secret.key
# Concatenate the ciphertext to pass them to GAHEL
# The cat command in more than enough
cat cipher3.tfhe cipher5.tfhe > cipherInput.tfhe

# The syntax is the following:
# gahel yourVerilogPath.v cloudKeyPath ciphertextInputPath ciphertextOutputPath
gahel simpleAdder.v cloud.key cipherInput.tfhe cipherOutput.tfhe
# Wait for GAHEL
# ...
# Now decrypt the output with the secret key
decrypt8 ciperOutput.tfhe secret.key
# You should get a 8!
```

## Repository Organization

- `src` contains source for utilities
- `core` contains core scripts for GAHEL
- `cnn` contains verilog source for running a CNn with half-precision floats
- `examples` contains examples for starting with GAHEL
- `support` contains script for installing or cleaning GAHEL installation
- `bin`,`lib`,`include` and `build` contains several files for making the whole infrastructure work.
  - `include` contains the `verilog` folder. This folder is automatically included in the verilog code
- `workspace` is the suggested folder where people should work.


## Tips

- Work in the `workspace` folder
- All the edits/new files/removed files  in the `gahel` folder reflects also outside the
   docker and viceversa

## TODOs

- Compare with other Homomorphic Encryption libraries
- Other accelerations (GPU)?
