

#include <stdio.h>
#include <stdlib.h>

#include "tfhe/tfhe.h"


int main(int argc, const char* argv[]){
   
union fp_bit_twiddler {
    float f;
    int i;
} q;

    if(argc<4){
        printf("Need 3 parameters!\nSyntax:\n\n%s encrypting-number <Output-Path> <Private-key Path>\n\n", argv[0]);
        return 2;
    } 
    q.f = atof(argv[1]);

    const int DIM=32;

    //Read the key
    FILE* secret_key = fopen(argv[3],"rb");
    if(secret_key==NULL){
        printf("Cannot open secret key path at %s\n",argv[4]);
        return 1;
    }
    
    FILE* output_fp = fopen(argv[2],"wb");
    if(secret_key==NULL){
        printf("Cannot open output path at %s\n",argv[3]);
        return 1;
    }
    printf("Encrypting %f...\n",q.f);
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);

    const TFheGateBootstrappingParameterSet* params = key->params;
    //const TFheGateBootstrappingSecretKeySet * params = key->params; 
    LweSample * ciphertext;
    for(int i=0; i<DIM; i++){
        ciphertext = new_gate_bootstrapping_ciphertext(params);
        fprintf(stderr, "Doing bit %d\n",i);
        bootsSymEncrypt(ciphertext,(q.i>>i)&1, key);
        export_gate_bootstrapping_ciphertext_toFile(output_fp,ciphertext,params);
    }
    fclose(output_fp);
    delete_gate_bootstrapping_ciphertext(ciphertext);
    return 0;
}
