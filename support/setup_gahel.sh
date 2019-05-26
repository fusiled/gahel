#!/bin/bash


set -e

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

TFHEDESTINATION="tfhe"
if [ ! -d "$TFHEDESTINATION" ] ; then
	git clone https://github.com/tfhe/tfhe $TFHEDESTINATION
else
	echo "Warning: Not cloning tfhe since destination folder ($TFHEDESTINATION) already exists"
fi

cd $TFHEDESTINATION
mkdir -p build; cd build; rm -drf ./*; cmake ../src -DENABLE_FFTW=on; make
cp libtfhe/*.so $GAHELLIB/

mkdir -p $GAHELINCLUDE/tfhe
cd ../
cp -dr src/include/*  $GAHELINCLUDE/tfhe

cd $GAHELBUILD

TASKFLOWDESTINATION="cpp-taskflow"
# Setup cpp-taskflow for abc
if [ ! -d "$TASKFLOWDESTINATION" ] ; then
    git clone https://github.com/cpp-taskflow/cpp-taskflow $TASKFLOWDESTINATION
else
    echo "Warning: Not cloning cpp-taskflow since destination folder ($TASKFLOWDESTINATION) already exists"
fi

mkdir -p taskflow_build
cd taskflow_build
rm -drf ./*
cmake -DCMAKE_INSTALL_PREFIX=$GAHELHOME ../$TASKFLOWDESTINATION
make -j
make -j install

cd $GAHELBUILD

ABCDESTINATION="abc"
#build abc
if [ ! -d "$ABCDESTINATION" ] ; then
	git clone https://gitlab.com/fusiled/abc $ABCDESTINATION
else
	echo "Warning: Not cloning abc since destination folder ($ABCDESTINATION) already exists"
fi

cd abc
make -j
ln -s $PWD/abc $GAHELBIN/abc
cp abc.rc $GAHELHOME/support/

#Build gahel support programs
cd $GAHELHOME/src
bash compile.sh


cd $CURDIR
