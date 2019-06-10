

#include <stdio.h>
#include <stdlib.h>

#include "tfhe/tfhe.h"

int main(int argc, const char* argv[]){
   
    if(argc<3){
        printf("Need 3 parameters!\nSyntax:\n\n%s bit-size ciphertext.tfhe <Private-key Path>\n\n",argv[0]);
        return 2;
    } 

    const int DIM=atoi(argv[1]);

    //Read the key
    FILE* secret_key = fopen(argv[3],"rb");
    if(secret_key==NULL){
        printf("Cannot open secret key path at %s\n",argv[2]);
        return 1;
    }
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);


    FILE* ciphertext_fp = fopen(argv[2],"rb");
    if(ciphertext_fp==NULL){
        printf("Cannot open ciphertext path at %s\n",argv[2]);
        return 1;
    }

    unsigned long result=0;
    const TFheGateBootstrappingParameterSet* params = key->params;
    LweSample * ciphertext;
    for(int i=0; i<DIM; i++){
        ciphertext = new_gate_bootstrapping_ciphertext(params);
        fprintf(stderr, "Doing bit %d\n",i);
        import_gate_bootstrapping_ciphertext_fromFile(ciphertext_fp,ciphertext,params);

        int bit = bootsSymDecrypt(ciphertext, key);
        result |= (bit<<i);
    }
    delete_gate_bootstrapping_ciphertext(ciphertext);
    fclose(ciphertext_fp);
    
    printf("%lu\n",result);
    return 0;
}
