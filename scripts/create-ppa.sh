#!/bin/bash

set -e

function usage() {
	echo "Usage: $0 <ppa id> [<options>]" >&2
	echo >&2
	echo "Build options:"
	echo "  --scope                      = public or private (default private)" >&2
	echo "  --origin=name                = Mainainer of the ppa (default ${USER})" >&2
	echo "  --label=name                 = Label of the ppa (default ppa name)" >&2
	echo "  --suite=value                = Type of ppa (default testing)" >&2
	echo >&2
	echo "Note: this scripts should be executed on the ppa hosting server" >2  
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi

ppa=$1

apt-get install reprepro dpkg-sig

#adduser $ppa --disabled-password

# sudo -----------------
sudo -u $ppa -s -- <<EOF

EOF
# end sudo -------------
	