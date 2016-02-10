This is the Cloud Application Support Toolkit for the Ubuntu distribution.

*Package Contents*

This package contains the following:
*	libcloudwave.so: The main library which must be linked against by any calling application.
*	cwdaemon: A command line tool which will populate the ‘in_memory’ data structure such that the SO may operate correctly.
*	waitforevent: A command line tool which will wait for a specified event.
*	sendevent: A command line tool which will send a specified event.
*	header files: A collection of header files to allow a developer to use cloudwave.so. See below for example code, which illustrates how these can be used.
*	installation script: A script which will install the above components into the correct directories. This will also install the toolkit’s dependencies. See below for more details. 

For the installation of the module execute the ubuntu_install.sh script (it needs root access to install the components).


