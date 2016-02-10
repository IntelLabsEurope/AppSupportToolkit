#!/usr/bin/env bash
#
###############################################################################
#Copyright 2015 INTEL RESEARCH AND INNOVATION IRELAND LIMITED
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
###############################################################################
#
# Small independent file to set up the required dependencies
#
# Assumes a simple Ubuntu 14 installation
# tested on 10.04 Server LTS with Openssh installed
#
###############################################################################
# Locations for everything
TMP=/tmp

MYHOME=$(pwd)

# clear any outstanding (and in case sudo was used !)
sudo rm -rf $TMP/cloudwave
# Make a staging directory
mkdir -p $TMP/cloudwave

###############################################################################
echo " "
echo " "
echo " $ ssh root@localhost"
echo " # visudo"
echo " add a line just under 'root  ALL = (ALL ) ALL"
echo "   with"
echo " your_user_name   ALL (ALL) ALL"
echo " "

###############################################################################

function print {
  echo -e '\e[33m\e[44m' $1 '\e[0m'
}

###############################################################################

print 'Ubuntu : Configuring Build Environment & cloudwave.so dependencies'


###############################################################################
#
# tools required
#
print 'Installing Development Tools'
sudo apt-get update -y
sudo apt-get -qy upgrade
sudo apt-get -qy install build-essential
sudo apt-get -qy install cmake
sudo apt-get -qy install swig
sudo apt-get -qy install make
sudo apt-get -qy install ruby
sudo apt-get -qy install help2man
sudo apt-get -qy install doxygen
sudo apt-get -qy install libboost-all-dev
sudo apt-get -qy install libuuid-perl libuuid1
sudo apt-get -qy install uuid-dev uuid-runtime
sudo apt-get -qy install python-qpid
sudo apt-get -qy install libcurl4-openssl-dev
sudo apt-get -qy install coreutils
sudo apt-get -qy install realpath
sudo apt-get -qy install unzip
#
sudo apt-get -qy install openjdk-7-jre
sudo apt-get -qy install openjdk-7-jre-lib
sudo apt-get -qy install openjdk-7-jdk
sudo apt-get -qy install libssl-dev
#
#
###############################################################################
## ------ qpid ------
## .. Version 2 support !
##
##
## http://svn.apache.org/repos/asf/qpid/trunk/qpid/cpp/INSTALL
##
## * boost      <http://www.boost.org>                    (1.41) (*)
## * libuuid    <http://kernel.org/~kzak/util-linux/>     (2.19)
## * pkgconfig  <http://pkgconfig.freedesktop.org/wiki/>  (0.21)
##
##
## VERSION 0.28
#print 'Install Qpid V0.28'
##
#pushd $TMP/cloudwave
#wget http://archive.apache.org/dist/qpid/0.28/qpid-0.28.tar.gz
#tar -xvzf qpid-0.28.tar.gz
#cd qpid-0.28
#cd cpp
#mkdir bld
#cd bld
##cmake ..
##cmake -DCMAKE_CXX_FLAGS="-std=c++11 -Wno-error=deprecated-declarations" ..
#cmake -DCMAKE_CXX_FLAGS="-std=c++0x -Wno-error=deprecated-declarations" ..
#make all
##
#sudo make install
## tools
#cd ../../tools
#sudo ./setup.py install
##
##
## VERSION 0.30 (Beta)
##print 'Install Qpid V0.30'
##
##wget -P $TMP http://mirror.ox.ac.uk/sites/rsync.apache.org/qpid/0.30/qpid-cpp-0.30.tar.gz
##
##pushd $TMP
##tar -xvzf qpid-cpp-0.30.tar.gz
##cd qpid-cpp-0.30
##mkdir bld
##cd bld
###cmake ..
###cmake -DCMAKE_CXX_FLAGS="-std=c++11 -Wno-error=deprecated-declarations" ..
##cmake -DCMAKE_CXX_FLAGS="-std=c++0x -Wno-error=deprecated-declarations" ..
##make all
###
##make install
##
##
#popd
##
#
# VERSION 0.34
print 'Install Qpid V0.34'
#
pushd $TMP/cloudwave
# wget http://www.apache.org/dist/qpid/cpp/0.34/qpid-cpp-0.34.tar.gz
#curl -# -o qpid-cpp-0.34.tar.gz http://www.apache.org/dist/qpid/cpp/0.34/qpid-cpp-0.34.tar.gz
wget http://www.apache.org/dist/qpid/cpp/0.34/qpid-cpp-0.34.tar.gz
tar -xvzf qpid-cpp-0.34.tar.gz
cd qpid-cpp-0.34
mkdir build
cd build
cmake ..
###cmake -DCMAKE_CXX_FLAGS="-std=c++11 -Wno-error=deprecated-declarations" ..
##cmake -DCMAKE_CXX_FLAGS="-std=c++0x -Wno-error=deprecated-declarations" ..
make all
sudo make install
popd
#
################################################################################
#
# Install rabbit
#
pushd $TMP/cloudwave
sudo apt-get -qy install rabbitmq-server
popd
#
#
################################################################################
#
# Install rabbitmq development
#
print 'Installing rabbitmq development'
#
pushd $TMP/cloudwave
wget https://github.com/alanxz/rabbitmq-c/archive/master.zip
unzip master.zip
cd rabbitmq-c-master
mkdir build
cd build
cmake ..
# make
cmake --build .
sudo make install
popd
#
################################################################################
#
print 'Installing Proton'
#
pushd $TMP/cloudwave
wget -q http://mirror.catn.com/pub/apache/qpid/proton/0.9.1/qpid-proton-0.9.1.tar.gz
tar xzf qpid-proton-0.9.1.tar.gz
cd qpid-proton-0.9.1-rc1
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON
make clean
make all docs
sudo make install
popd
#
################################################################################
#
#
print 'Installing jansson'
#
pushd $TMP/cloudwave
wget http://www.digip.org/jansson/releases/jansson-2.7.tar.gz
tar -xvzf jansson-2.7.tar.gz
cd jansson-2.7/
./configure
make
sudo make install
popd

################################################################################
## We need the Python qpidd config files .. install these
## version 2 support
##
#sudo yum install python-qpid
##
################################################################################

# update the ldconfig, write out a tmp file
#
print 'Setup the linker cache'
# --------------
# Update the linker cache
LIBFILE="usrlocal.conf"
/bin/cat <<EOM >$LIBFILE
#
# Make libraries available
# # required for rabbit-mq
/usr/local/lib/x86_64-linux-gnu
#
EOM
#
# Copy this to the ldconf location
sudo mv $LIBFILE /etc/ld.so.conf.d/
#
sudo ldconfig
#
###############################################################################

# Get back home, and tidy up

print 'Tidy Up'
sudo rm -rf $TMP/cloudwave
#
#
cd $MYHOME

print 'finished'

