cc -o $GAHELHOME/bin/keygen keygen.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/encrypt8 encrypt8.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/decrypt8 decrypt8.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/encryptN encryptN.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/decryptN decryptN.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/encryptFloat encryptFloat.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/decryptFloat decryptFloat.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/decryptFloatArray decryptFloatArray.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
