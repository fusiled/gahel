cc -o $GAHELHOME/bin/keygen keygen.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/encrypt8 encrypt8.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
cc -o $GAHELHOME/bin/decrypt8 decrypt8.c -L$GAHELHOME/lib -ltfhe-nayuki-portable -I$GAHELHOME/include
