#!/bin/bash

set -e

xpl_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

function usage() {
	echo "Usage: $0 <ppa> [<options>]" >&2
	echo >&2
	echo "Options:"
	echo "  --force                      = overwrite whole ppa if already exists" >&2
	echo "  --ssh                        = ppa has private ssh access" >&2
	echo "  --http                       = ppa has public http access" >&2
	echo "  --add                        = add ppa configuration to apt" >&2
	echo >&2
	echo "Note: this scripts should be executed on the ppa hosting server" >2  
}

if [ $# -lt 1 ]
then
	usage
	exit 1
fi


opt_force=0
opt_ssh=0
opt_http=0
opt_add=0
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
	elif [[ "$filt_arg" == "--ssh" ]]; then
	    opt_ssh=1
	elif [[ "$filt_arg" == "--http" ]]; then
	    opt_http=1
	elif [[ "$filt_arg" == "--add" ]]; then
	    opt_add=1
	else
	    ppa=$filt_arg
	fi
	
	shift
done

# check if ppa exists
exist=0
id -u $ppa 2>/dev/null 1>/dev/null && exist=1
if [ $exist -eq 1 ] && [ $opt_force -eq 1 ]
then
	echo "Droping $ppa"
	# drop ppa
	deluser $ppa --remove-home >/dev/null
	exist=0
elif [ $exist -eq 1 ]
then
	echo "Error: $ppa already exists" >&2
	exit 1
fi

# create ppa
[ $exist -eq 0 ] && adduser $ppa --disabled-password --quiet --gecos ""

# sudo -----------------
# create stable and testing repo
su - $ppa <<ESU
echo "{}" > .aptly.conf
mkdir -p .ssh
mkdir -p dropin
aptly repo create stable >/dev/null 
aptly repo create testing >/dev/null
ESU
# end sudo -------------

if [ $opt_ssh -eq 1 ] || [ $opt_ssh -eq 1 ]
then
	rm -f /etc/apt/sources.list.d/${ppa}.list
	touch /etc/apt/sources.list.d/${ppa}.list
fi

if [ $opt_ssh -eq 1 ]
then
	echo
	echo "Configuration for ssh access: "
	echo "deb [ arch=amd64 ] ssh://${ppa}@$(hostname)/home/${ppa}/.aptly/public/testing rosa main"
	echo "deb [ arch=amd64 ] ssh://${ppa}@$(hostname)/home/${ppa}/.aptly/public/stable rosa main"
	echo 
	echo "Enable your ssh access with the following commands, for the user and for root: "
	echo "cat ~/.ssh/id_rsa.pub | ssh root@$(hostname) 'cat - >> /home/${ppa}/.ssh/authorized_keys'"
	echo "sudo cat ~/.ssh/id_rsa.pub | ssh root@$(hostname) 'cat - >> /home/${ppa}/.ssh/authorized_keys'"
		
	if [ $opt_add -eq 1 ]
	then
		echo "#deb ssh://${ppa}@$(hostname) ${distribution} testing main" >> /etc/apt/sources.list.d/${ppa}.list
		echo "#deb ssh://${ppa}@$(hostname) ${distribution} stable main" >> /etc/apt/sources.list.d/${ppa}.list
		echo "Configuration added to /etc/apt/sources.list.d/${ppa}.list, enable the repository you want to use by uncommenting it"		
	fi
fi

if [ $opt_http -eq 1 ]
then
	echo "Error: --http not yet implemented"
	exit 1
	
	echo
	echo "Configuration for http access: "
	echo "deb http://$(hostname)/${ppa} testing main"
	echo "deb http://$(hostname)/${ppa} stable main"
	
	if [ $opt_add -eq 1 ]
	then
		echo "deb http://$(hostname) ${distribution} testing main" >> /etc/apt/sources.list.d/${ppa}.list
		echo "deb http://$(hostname) ${distribution} stable main" >> /etc/apt/sources.list.d/${ppa}.list
		echo "Configuration added to /etc/apt/sources.list.d/${ppa}.list"		
	fi
fi