#!/usr/bin/env bash

# Get # of processors in environment variables.
export NP=$(nproc)
# Store current location as working directory.
export WORK_DIR=${PWD}

# Update packages fromt apt repos.
sudo apt-get update
sudo apt-get -y install build-essential gfortran wget less m4 git cmake
sudo apt-get -y install openmpi-bin libopenmpi-dev \
sudo apt-get -y install libpetsc3.6 libpetsc3.6.2-dbg libpetsc3.6.2-dev
sudo apt-get -y install libslepc3.6 libslepc3.6.1-dbg libslepc3.6.1-dev
sudo apt-get -y install libparpack2-dev
sudo apt-get -y install libboost-all-dev
sudo apt-get -y install libeigen3-dev

# Fetch/build libMesh.
mkdir libmesh
cd libmesh
wget https://github.com/libMesh/libmesh/releases/download/v1.3.1/libmesh-1.3.1.tar.gz
tar -xvf libmesh-1.3.1.tar.gz
cd libmesh-1.3.1
mkdir build
cd build
export PETSC_DIR=/usr/lib/petscdir/3.6.2/x86_64-linux-gnu-real
export SLEPC_DIR=/usr/lib/slepcdir/3.6.1/x86_64-linux-gnu-real
export HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/openmpi
../configure --prefix=/usr/local --with-methods="opt dbg" --disable-metaphysicl --disable-examples
make -j ${NP}
sudo make install

# Organize libMesh include/ and lib/ for packaging.
cd ${WORK_DIR}
export PKG_DIR=libmesh-1.3.1-1
export INST_DIR=${PKG_DIR}/usr/local
mkdir ${PKG_DIR}
mkdir ${PKG_DIR}/usr
mkdir ${PKG_DIR}/usr/local
mkdir ${PKG_DIR}/usr/local/include
mkdir ${PKG_DIR}/usr/local/lib
cp -r /usr/local/include/* ${INST_DIR}/include
cp -r /usr/local/lib/libmesh* ${INST_DIR}/lib
cp -r /usr/local/lib/libnetcdf* ${INST_DIR}/lib

# Copy in DEBIAN/control package configuration file.
cp -r ${WORK_DIR}/DEBIAN ${PKG_DIR}

# Create libMesh .deb package.
dpkg-deb --build libmesh-1.3.1-1
