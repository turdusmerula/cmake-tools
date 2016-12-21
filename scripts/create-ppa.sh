#!/bin/bash

set -e

function usage() {
	echo "Usage: $0 <ppa id> [<options>]" >&2
	echo >&2
	echo "Build options:"
	echo "  --force                      = overwrite ppa if already exists" >&2
	echo >&2
	echo "Note: this scripts should be executed on the ppa hosting server" >2  
}

if [ $# -lt 1 ]
then
	usage
	exit 1
fi

opt_force=0

while [[ "_$*" != "_" ]]
do
    if [ "_$(echo "$1" | grep '=')" != "_" ]
    then
        filt_arg="$(echo $1 | sed "s#\(.*\)=.*#\1#g")"
        value_arg="$(echo $1 | sed "s#.*=\(.*\)#\1#g")"
    else
        filt_arg=$1
        unset value_arg
    fi

	if [[ "$filt_arg" == "--force" ]]; then
	    opt_force=1
	else
	    ppa=$filt_arg
	fi
	
	shift
done
echo "#### $ppa"
# check if ppa exists
exist=0
id -u $ppa 2>/dev/null 1>/dev/null && exists=1 

if [ $exist -eq 1 ] && [ $opt_force -eq 1 ]
then
	echo "Droping $ppa"
	# drop ppa
	deluser $ppa
	exist=0
elif [ $exist -eq 1 ]
then
	echo "Error: $ppa already exists" >&2
	exit 1
fi

# create ppa
[ $exist -eq 0 ] && adduser $ppa --disabled-password

# sudo -----------------
sudo -u $ppa -s -- <<EOF
# create stable and testing repo
aptly repo create stable
aptly repo create testing
EOF
# end sudo -------------
	