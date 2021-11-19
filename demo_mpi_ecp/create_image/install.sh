# install mpich
wget --no-verbose http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz
tar xf mpich-3.4.2.tar.gz
rm mpich-3.4.2.tar.gz
# installtion folder
mkdir /mpich
# build folder
mkdir /mpich-build
cd /mpich-build
/mpich-3.4.2/configure --prefix=/mpich --with-device=ch4:ofi --disable-fortran --silence 2>&1 | tee c.txt
make -s LIBTOOLFLAGS=--silent -V -j4 2>&1 | tee m.txt
make -s install 2>&1 | tee mi.txt
echo 'export PATH="/mpich/bin:$PATH"' >> ~/.bashrc
export PATH="/mpich/bin:$PATH"
cd /

# python3 is already installed in gcc:9.4 
# install pip
pip install --upgrade pip

# install mpi4py
pip install --force --no-cache-dir --no-binary=mpi4py mpi4py

rm -rf /mpich-build
rm -rf /mpich-3.4.2

mkdir /mpich-demo
mkdir /mpich-demo/c
mkdir /mpich-demo/py

