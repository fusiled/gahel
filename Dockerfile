FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

#Install required packages
WORKDIR /tmp
RUN apt-get -y update && apt-get -y install vim build-essential \
        gdb gdb-dbg wget git m4 libfftw3-3 libfftw3-dev yosys yosys-dev yosys-doc cmake libreadline-dev
WORKDIR /gahel 
