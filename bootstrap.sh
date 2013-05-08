#!/usr/bin/env bash

die() {
   [[ $# -gt 1 ]] && { 
        exit_status=$1
        shift        
    } 
    local -i frame=0; local info= 
    while info=$(caller $frame)
    do 
        local -a f=( $info )
        [[ $frame -gt 0 ]] && {
            printf >&2 "ERROR in \"%s\" %s:%s\n" "${f[1]}" "${f[2]}" "${f[0]}"
        }
        (( frame++ )) || :; #ignore increment errors (i.e., errexit is set)
    done

    printf >&2 "ERROR: $*\n"

    exit ${exit_status:-1}
}

#trap 'die $? "*** bootstrap failed. ***"' ERR

set -o nounset -o pipefail


apt-get update

##!! need answers

apt-get -y install debconf-utils


# BAD requires interaction
#apt-get -y install slapd

# http://www.linuxforums.org/forum/ubuntu-linux/191660-script-install-slapd-admin-ldap-password.html

# option 1
#sudo debconf-set-selections <<< 'slapd/root_password password your_password'
#sudo debconf-set-selections <<< 'slapd/root_password_again password your_password'
#sudo aptitude -y install slapd

#option 2

installnoninteractive(){
  DEBIAN_FRONTEND=noninteractive apt-get install -q -y $*
}

installnoninteractive slapd ldap-utils

