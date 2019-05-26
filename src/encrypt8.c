

#include <stdio.h>
#include <stdlib.h>

#include "tfhe/tfhe.h"

#define DIM 8

int main(int argc, const char* argv[]){
   
    if(argc<4){
        printf("Need 3 parameters!\nSyntax:\n\n%s <%d-bits Number> <Output-Path> <Private-key Path>\n\n", argv[0], DIM);
        return 2;
    } 
    unsigned long number = strtoul(argv[1],NULL,10);

    //Read the key
    FILE* secret_key = fopen(argv[3],"rb");
    if(secret_key==NULL){
        printf("Cannot open secret key path at %s\n",argv[3]);
        return 1;
    }
    
    FILE* output_fp = fopen(argv[2],"wb");
    if(secret_key==NULL){
        printf("Cannot open output path at %s\n",argv[2]);
        return 1;
    }
    printf("Encrypting %lu...\n",number);
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);

    const TFheGateBootstrappingParameterSet* params = key->params;
    //const TFheGateBootstrappingSecretKeySet * params = key->params; 
    LweSample * ciphertext;
    for(int i=0; i<DIM; i++){
        ciphertext = new_gate_bootstrapping_ciphertext(params);
//        fprintf(stderr, "Doing bit %d\n",i);
        bootsSymEncrypt(ciphertext,(number>>i)&1, key);
        export_gate_bootstrapping_ciphertext_toFile(output_fp,ciphertext,params);
    }
    fclose(output_fp);
    delete_gate_bootstrapping_ciphertext(ciphertext);
    return 0;
}
