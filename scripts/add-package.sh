#!/bin/bash

set -e

xpl_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

distribution=$(${xpl_path}/get-distribution.sh)

function usage() {
	echo "Usage: $0 <server> <ppa> <repository> <package> [<options>]" >&2
	echo >&2
	echo "Options:"
	echo "  --distribution=name          = change distribution (default=${distribution})" >&2
	echo >&2
}

if [ $# -lt 4 ]
then
	usage
	exit 1
fi


server=""
ppa=""
repository=""
package=""
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

	if [[ "$filt_arg" == "--distribution" ]]; then
	    distribution=$value_arg
	elif [[ "_$server" == "_" ]]; then
	    server=$filt_arg
	elif [[ "_$ppa" == "_" ]]; then
	    ppa=$filt_arg
	elif [[ "_$repository" == "_" ]]; then
	    repository=$filt_arg
	elif [[ "_$package" == "_" ]]; then
	    package=$filt_arg
	fi
	
	shift
done

# copy file to add to repo
scp $package ${ppa}@${server}:/home/${ppa}/dropin/

# add file to repo
ssh ${ppa}@${server} aptly repo add ${repository} /home/${ppa}/dropin/$(basename $package)

# cleanup
ssh ${ppa}@${server} rm -f /home/${ppa}/dropin/$(basename $package)

# deploy repo
if [ "_$(ssh ${ppa}@${server} aptly publish list | grep ${repository}/)" == "_" ]
then
	ssh ${ppa}@${server} aptly publish repo -skip-signing=true -distribution=${distribution} -architectures=amd64 ${repository} ${repository}
else
	ssh ${ppa}@${server} aptly publish update -skip-signing=true ${distribution} ${repository} 
fi
