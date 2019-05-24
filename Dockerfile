FROM ubuntu:18.04

#Install required packages
WORKDIR /tmp
RUN apt-get -y update && apt-get -y install vim build-essential \
        wget git m4 libfftw3-3 libfftw3-dev yosys-dev cmake
