#!/bin/bash


set -e

CURDIR="$PWD"

GAELBUILD="$GAELHOME/build"
GAELLIB="$GAELHOME/lib"
GAELBIN="$GAELHOME/bin"
GAELWORKSPACE="$GAELHOME/workspace"

#Create needed dirs
mkdir -p $GAELBUILD
mkdir -p $GAELLIB
mkdir -p $GAELWORKSPACE

# build tfhe for homomorphic encryption and copy
# the built libraries
cd $GAELBUILD
git clone https://github.com/tfhe/tfhe
cd tfhe
make
cp build/libtfhe/* $GAELLIB/
#build abc
git clone https://gitlab.com/fusiled/abc
make -j
ln -s ./abc $GAELBIN/abc


#Build gael support programs
cd $GAELHOME/src
bash compile.sh


cd $CURDIR
