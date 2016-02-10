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
#
###############################################################################

function print {
  echo -e '\e[33m\e[44m' $1 '\e[0m'
}

###############################################################################
#
print 'Install the include files'
sudo rm -rf /usr/local/include/cloudwave
sudo mkdir -p /usr/local/include/cloudwave
sudo install inc/*.h /usr/local/include/cloudwave
#
print 'Install the SO library'
sudo rm -f /usr/local/lib/libcloudwave.*
sudo install lib/libcloudwave.so /usr/local/lib/libcloudwave.so.1
sudo ln -s /usr/local/lib/libcloudwave.so.1 /usr/local/lib/libcloudwave.so
#
print 'Install the system files'
sudo install system/* /usr/local/bin
#
# Optional
print 'Install the utility files'
sudo install util/* /usr/local/bin
#
#
################################################################################
# update the ldconfig
#
print 'Setup the linker cache'
sudo ldconfig
#

