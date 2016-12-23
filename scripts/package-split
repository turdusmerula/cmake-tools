#!/bin/bash

set -e

function usage() {
	echo "Usage: $0 <debian file>" >&2
	echo >&2
	echo "This script is intended to be used in addition to checkinstall to produce retail and dev package." >&2
	echo "" >&2
	echo "Package must be named <package>-all_<version>_<arch>.deb" >&2
	echo "Script will produce 2 files:" >&2
	echo "  <package>_<version>_<arch>.deb for retail version" >&2
	echo "  <package>-dev_<version>_<arch>.deb for dev version" >&2
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi

deb_file=$1
deb_dev_file=$(basename ${deb_file} | sed -e "s#\(.*\)-all_\(.*\)#\1-dev_\2#g")
deb_retail_file=$(basename ${deb_file} | sed -e "s#\(.*\)-all_\(.*\)#\1_\2#g")

pkg_name=$(basename ${deb_file} | sed -e "s#\(.*\)-all_.*#\1#g")
pkg_all_name=$(basename ${deb_file} | sed -e "s#\(.*-all\)_.*#\1#g")
pkg_dev_name=$(basename ${deb_file} | sed -e "s#\(.*\)-all_.*#\1-dev#g")
pkg_retail_name=$(basename ${deb_file} | sed -e "s#\(.*\)-all_.*#\1#g")

install=0
[[ "_$(dpkg -l | grep ${pkg_name})" == "_" ]] || install=1

# remove packages
[ $install -eq 1 ] && dpkg -r ${pkg_all_name}
[ $install -eq 1 ] && dpkg -r ${pkg_dev_name}
[ $install -eq 1 ] && dpkg -r ${pkg_retail_name}

rm -rf /tmp/split-deb-dev
mkdir /tmp/split-deb-dev

# unpack debian package
dpkg-deb -x ${deb_file} /tmp/split-deb-dev
dpkg-deb --control ${deb_file} /tmp/split-deb-dev/DEBIAN

function create_retail() {
	retail_name=$(basename ${deb_file} | sed -e 's#-all##g')
	
	# copy package structure
	rm -rf /tmp/split-deb-retail
	mkdir /tmp/split-deb-retail
	cp -rf /tmp/split-deb-dev/DEBIAN /tmp/split-deb-retail
	
	# modify control file
	sed -i -e "s#\(Package: .*\)-all#\1#g" /tmp/split-deb-retail/DEBIAN/control
	sed -i -e '/Installed-Size:.*/d' /tmp/split-deb-retail/DEBIAN/control
	sed -i -e "s#\(Provides: .*\)-all#\1#g" /tmp/split-deb-retail/DEBIAN/control

	# copy so files
	for file in $(find /tmp/split-deb-dev -name "*.so*" -o -name "*.a")
	do
		relfile=$(echo $file | sed "s#/tmp/split-deb-dev/##g")
		path=$(dirname $relfile)
		name=$(basename $relfile)
		
		mkdir -p /tmp/split-deb-retail/${path}
		cp -a ${file} /tmp/split-deb-retail/${path}/
	done
	
	# create package
	dpkg -b /tmp/split-deb-retail ${retail_name}
}

function create_dev() {
	dev_name=$(basename ${deb_file} | sed -e 's#-all#-dev#g')
	
	# remove so from dev package
	find /tmp/split-deb-dev -name "*.so*" -type f -exec rm -f {} \;
	find /tmp/split-deb-dev -name "*.so*" -type l -exec rm -f {} \;
	find /tmp/split-deb-dev -name "*.a" -type f -exec rm -f {} \;
		
	# modify control file
	retail_name=$(grep "Package:" /tmp/split-deb-dev/DEBIAN/control | sed -e "s#Package: \(.*\)-all#\1#g")
	sed -i -e '/Installed-Size:.*/d' /tmp/split-deb-dev/DEBIAN/control
	sed -i -e '/Depends:.*/d' /tmp/split-deb-dev/DEBIAN/control
	sed -i -e 's/-all/-dev/g' /tmp/split-deb-dev/DEBIAN/control
	echo "Depends: ${retail_name}" >> /tmp/split-deb-dev/DEBIAN/control
	
	# remove empty directories
	while [ -n "$(find /tmp/split-deb-dev -depth -type d -empty -exec rmdir {} +)" ]; do :; done
	
	# create package
	dpkg -b /tmp/split-deb-dev ${dev_name}
}

# create retail package
create_retail

# create dev package
create_dev

#install packages
[ $install -eq 1 ] && dpkg -i ${deb_retail_file}
[ $install -eq 1 ] && dpkg -i ${deb_dev_file}

# cleanup
rm -rf /tmp/split-deb-dev
rm -rf /tmp/split-deb-retail

