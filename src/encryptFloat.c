

#include <stdio.h>
#include <stdlib.h>

#include "tfhe/tfhe.h"

unsigned short toFloat16(unsigned short fltInt32) {
	unsigned short fltInt16 = (fltInt32 >> 31) << 5;
	unsigned short tmp = (fltInt32 >> 23) & 0xff;
	tmp = (tmp - 0x70) & ((unsigned int)((int)(0x70 - tmp) >> 4) >> 27);
	fltInt16 = (fltInt16 | tmp) << 10;
	fltInt16 |= (fltInt32 >> 13) & 0x3ff;
	return fltInt16;
}


uint16_t canardConvertNativeFloatToFloat16(float value)
{
    union FP32
    {
        uint32_t u;
        float f;
    };

    const union FP32 f32inf = { 255UL << 23 };
    const union FP32 f16inf = { 31UL << 23 };
    const union FP32 magic = { 15UL << 23 };
    const uint32_t sign_mask = 0x80000000U;
    const uint32_t round_mask = ~0xFFFU;

    union FP32 in;
    in.f = value;
    uint32_t sign = in.u & sign_mask;
    in.u ^= sign;

    uint16_t out = 0;

    if (in.u >= f32inf.u)
    {
        out = (in.u > f32inf.u) ? (uint16_t)0x7FFFU : (uint16_t)0x7C00U;
    }
    else
    {
        in.u &= round_mask;
        in.f *= magic.f;
        in.u -= round_mask;
        if (in.u > f16inf.u)
        {
            in.u = f16inf.u;
        }
        out = (uint16_t)(in.u >> 13);
    }

    out |= (uint16_t)(sign >> 16);

    return out;
}



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

    const int DIM=16;

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
    unsigned short f16Number = canardConvertNativeFloatToFloat16(q.f);
    for(int i=0; i<DIM; i++){
        ciphertext = new_gate_bootstrapping_ciphertext(params);
        fprintf(stderr, "Doing bit %d: %u\n",i, (f16Number>>i)&1 );
        bootsSymEncrypt(ciphertext,(f16Number>>i)&1, key);
        export_gate_bootstrapping_ciphertext_toFile(output_fp,ciphertext,params);
    }
    fclose(output_fp);
    delete_gate_bootstrapping_ciphertext(ciphertext);
    return 0;
}
