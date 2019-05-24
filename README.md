# GAEL : GAte Encryption Library


GAEL is able to perform **ANY** kind of homomorphic operation. It combines
the Verilog programming language to produce a gate-list that uses homomorphic
encryption to perform computation over encrypted data in a gate-level style.


## Quickstart
To setup GAEL:
```
git clone <something>
cd gael
#This will build a docker image end enter in it
bash launch.sh
#This will build what gael needs
bash support/setup_gael.sh
```

You can re-enter in the docker container re-running `bash launch.sh`.
The container will be resumed.

To run an 8-bit adder with 3 and 5 as input we can use an example (from the 
container environment):
```
# Copy the example folder in the workspace
cp /gael/examples/simpleAdder /gael/workspace/
cd /gale/workspace/simpleAdder
# Let's encrypt 3 and 5 with secret.key contained in the folder
encrypt8 3 secret.key > cipher3.tfhe
encrypt8 5 secret.key > cipher5.tfhe
# Concatenate the ciphertext to pass them to GAEL
# The cat command in more than enough
cat cipher3.tfhe cipher5.tfhe > cipherInput.tfhe

# The syntax is the following:
# gael yourVerilogPath.v cloudKeyPath ciphertextInputPath ciphertextOutputPath
gael simpleAdder.v cloud.key cipherInput.tfhe cipherOutput.tfhe
# Wait for GAEL
# ...
# Now decrypt the output with the secret key
decrypt8 ciperOutput.tfhe secret.key
# You should get a 8!
```

## Tips

- Work in the `workspace` folder
- All the edits/new files/removed files  in the `gael` folder reflects also outside the
   docker and viceversa

## TODOs

- Compare with other Homomorphic Encryption libraries
- Other accelerations (GPU)?
