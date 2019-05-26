# GAHEL : GAte Homomorphic Encryption Library


GAHEL is able to perform **ANY** kind of homomorphic operation. It combines
the Verilog programming language to produce a gate-list that uses homomorphic
encryption to perform computation over encrypted data in a gate-level style.


## Quickstart
To setup GAHEL:
```
git clone <something>
cd gahel
#This will build a docker image end enter in it
bash launch.sh
#This will build what gahel needs
bash support/setup_gahel.sh
```

You can re-enter in the docker container re-running `bash launch.sh`.
The container will be resumed.

To run an 8-bit adder with 3 and 5 as input we can use an example (from the 
container environment):
```
# Copy the example folder in the workspace
cp /gahel/examples/simpleAdder /gahel/workspace/
cd /gale/workspace/simpleAdder
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

## Tips

- Work in the `workspace` folder
- All the edits/new files/removed files  in the `gahel` folder reflects also outside the
   docker and viceversa

## TODOs

- Compare with other Homomorphic Encryption libraries
- Other accelerations (GPU)?
