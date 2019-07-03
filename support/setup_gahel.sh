#!/bin/bash


set -e


NCORES="4"

CURDIR="$PWD"

GAHELBUILD="$GAHELHOME/build"
GAHELLIB="$GAHELHOME/lib"
GAHELBIN="$GAHELHOME/bin"
GAHELINCLUDE="$GAHELHOME/include"
GAHELWORKSPACE="$GAHELHOME/workspace"



#Create needed dirs
mkdir -p $GAHELBUILD
mkdir -p $GAHELLIB
mkdir -p $GAHELWORKSPACE
mkdir -p $GAHELINCLUDE
mkdir -p $GAHELBIN

#Link gahel launcher
ln -s $GAHELHOME/core/gahel $GAHELBIN

# build tfhe for homomorphic encryption and copy
# the built libraries
cd $GAHELBUILD

TFHEDESTINATION="cufhe"
if [ ! -d "$TFHEDESTINATION" ] ; then
	git clone https://github.com/vernamlab/cuFHE $TFHEDESTINATION
else
	echo "Warning: Not cloning tfhe since destination folder ($TFHEDESTINATION) already exists"
fi

cd $TFHEDESTINATION/cufhe
make
cp bin/*.so $GAHELLIB/

mkdir -p $GAHELINCLUDE/tfhe
cp -dr include/*  $GAHELINCLUDE/tfhe

cd $GAHELBUILD

cd $GAHELBUILD

ABCDESTINATION="abc"
#build abc
if [ ! -d "$ABCDESTINATION" ] ; then
	git clone https://gitlab.com/fusiled/abc $ABCDESTINATION
else
	echo "Warning: Not cloning abc since destination folder ($ABCDESTINATION) already exists"
fi

cd abc
make -j$NCORES
ln -s $PWD/abc $GAHELBIN/abc
cp abc.rc $GAHELHOME/support/

#Build gahel support programs
cd $GAHELHOME/src
bash compile.sh


cd $CURDIR
