#!/bin/bash

# Get the next release number of a package on repository

function usage() {
	echo "Usage: $0 <ppa> <mirror> <package> <version>" >&2
}

xpl_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

ppa=$1
mirror=$2
package=$3
version=$4

if [ $# -ne 4 ]
then
	usage
	exit 1
fi

${xpl_path}/check-ssh.sh $ppa $mirror || exit 1

# ssh -----------------
ssh ${ppa}@${mirror} <<EOF
set -e

aptly package search "${package} (${version})" 2>/dev/null

EOF
# end ssh -------------
if [ $? -ne 0 ]
then
	echo 1
fi

exit 0