#!/bin/bash
sudo apt-get update > $SCRATCH/logs/install.log
sudo apt-get -y install git \
                   build-essential \
                   libtool \
                   autotools-dev \
                   automake \
                   autoconf \
                   debootstrap \
                   yum \
                   python3-pip >> $SCRATCH/logs/install.log

# Install Singularity from Github
cd /tmp && git clone http://www.github.com/singularityware/singularity 
cd /tmp/singularity && ./autogen.sh && ./configure --prefix=/usr/local && make && sudo make install
cd $RUNDIR
