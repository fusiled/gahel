

#include <stdio.h>
#include <stdlib.h>

#include "tfhe/tfhe.h"


float canardConvertFloat16ToNativeFloat(uint16_t value)
{
    union FP32
    {
        uint32_t u;
        float f;
    };

    const union FP32 magic = { (254UL - 15UL) << 23 };
    const union FP32 was_inf_nan = { (127UL + 16UL) << 23 };
    union FP32 out;

    out.u = (value & 0x7FFFU) << 13;
    out.f *= magic.f;
    if (out.f >= was_inf_nan.f)
    {
        out.u |= 255UL << 23;
    }
    out.u |= (value & 0x8000UL) << 16;

    return out.f;
}


int main(int argc, const char* argv[]){

union fp_bit_twiddler {
    float f;
    int i;
} q;

    if(argc<3){
        printf("Need 2 parameters!\nSyntax:\n\n%s ciphertext.tfhe <Private-key Path>\n\n",argv[0]);
        return 2;
    } 

    const int DIM=16;

    //Read the key
    FILE* secret_key = fopen(argv[2],"rb");
    if(secret_key==NULL){
        printf("Cannot open secret key path at %s\n",argv[2]);
        return 1;
    }
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);


    FILE* ciphertext_fp = fopen(argv[1],"rb");
    if(ciphertext_fp==NULL){
        printf("Cannot open ciphertext path at %s\n",argv[2]);
        return 1;
    }

    unsigned int result=0;
    const TFheGateBootstrappingParameterSet* params = key->params;
    LweSample * ciphertext;
    unsigned short f16Value = 0;
    for(int i=0; i<DIM; i++){
        ciphertext = new_gate_bootstrapping_ciphertext(params);
        fprintf(stderr, "Doing bit %d: ",i);
        import_gate_bootstrapping_ciphertext_fromFile(ciphertext_fp,ciphertext,params);

        unsigned short bit = bootsSymDecrypt(ciphertext, key);
        f16Value |= (bit<<i);
	printf("%u\n",bit);
    }
    delete_gate_bootstrapping_ciphertext(ciphertext);
    fclose(ciphertext_fp);
    
    printf("%f\n",canardConvertFloat16ToNativeFloat(f16Value));
    return 0;
}
