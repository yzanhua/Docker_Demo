FROM ubuntu:latest
WORKDIR /app

RUN \
    apt-get update        && \
    apt-get install --yes    \
        build-essential      \
        python3-pip          \
        wget              && \
    apt-get clean all

ARG mpich=3.4.2
ARG mpich_prefix=mpich-$mpich

RUN \
    wget -nv https://www.mpich.org/static/downloads/$mpich/$mpich_prefix.tar.gz && \
    gzip -dc $mpich_prefix.tar.gz | tar -xf -                    && \
    cd $mpich_prefix                                             && \
    ./configure --prefix=/usr/local --silent --disable-fortran --with-device=ch4:ofi && \
    make -s LIBTOOLFLAGS=--silent V=1 -j4 2>&1 | tee 0.txt       && \
    make -s install 2>&1 | tee 1.txt                             && \
    cd ..                                                        && \
    rm -rf $mpich_prefix $mpich_prefix.tar.gz

ARG hdf5_ver=1.12
ARG hdf5_ver_sub=1
ARG hdf5_prefix=hdf5-$hdf5_ver.$hdf5_ver_sub

RUN \
    wget -nv https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$hdf5_ver/$hdf5_prefix/src/$hdf5_prefix.tar.gz && \
    gzip -dc $hdf5_prefix.tar.gz |tar -xf -                      && \
    cd $hdf5_prefix                                              && \
    ./configure --prefix=/usr/local --silent --disable-fortran --disable-cxx --enable-parallel=yes --enable-build-mode=production CC=mpicc && \
    make -s LIBTOOLFLAGS=--silent V=1 -j4 2>&1 | tee 0.txt       && \
    make -s install 2>&1 | tee 1.txt                             && \
    cd ..                                                        && \
    rm -rf $hdf5_prefix $hdf5_prefix.tar.gz

ARG mpi4py=3.1.1
ARG mpi4py_prefix=mpi4py-$mpi4py

RUN \
    wget -nv https://bitbucket.org/mpi4py/mpi4py/downloads/$mpi4py_prefix.tar.gz && \
    gzip -dc $mpi4py_prefix.tar.gz |tar -xf -                                    && \
    cd $mpi4py_prefix                                                            && \
    python3 setup.py build                                                       && \
    python3 setup.py install                                                     && \
    cd ..                                                                        && \
    rm -rf $mpi4py_prefix $mpi4py_prefix.tar.gz

RUN \
    export LD_LIBRARY_PATH=/usr/local/lib && \
    export HDF5_MPI=ON && \
    export HDF5_DIR=/usr/local && \
    export CC=/usr/local/bin/mpicc && \
    pip install --force --no-cache-dir --no-deps --no-binary=h5py h5py

RUN \
    pip install --force --no-cache-dir numpy pandas boost_histogram               && \
    pip install --force --no-cache-dir torch                                      && \
    pip install --force --no-cache-dir torch-scatter torch-sparse torch-geometric && \
    pip install --force --no-cache-dir particle

RUN /sbin/ldconfig
