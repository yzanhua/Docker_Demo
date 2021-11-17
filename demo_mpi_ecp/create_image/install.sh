# run a new container using image gcc version 9.4
# you can choose a different version.
# supported version: https://hub.docker.com/_/gcc?tab=tags

# numa.h needed by mpich
apt-get -qq update
apt-get install -qqy libnuma-dev

# install mpich
wget http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz
tar xf mpich-3.4.2.tar.gz
rm mpich-3.4.2.tar.gz
# installtion folder
mkdir /mpich
# build folder
mkdir /mpich-build
cd mpich-build
/mpich-3.4.2/configure -prefix=/mpich --with-device=ch4:ucx --disable-fortan 2>&1 | tee c.txt
make 2>&1 | tee m.txt
make install 2>&1 | tee mi.txt 
echo 'export PATH="/mpich/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
cd /

# install python3 
apt-get -qq update
apt-get install -qqy python3

# install pip
apt-get install -qqy python3-pip

# install mpi4py
python3 -m pip install --upgrade pip
python3 -m pip install mpi4py

rm -rf /mpich-build
rm -rf /mpich-3.4.2

mkdir /mpich-demo
mkdir /mpich-demo/c
mkdir /mpich-demo/py