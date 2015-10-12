#!/bin/bash
if [ "$EUID" -eq 0 ]
  then echo "Please DO NOT run as root!"
  exit
fi

OPTION_FORCE=0
if [ "$1" = "-f" ];then
  OPTION_FORCE=1
fi

OLDDIR=$(pwd)

function vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

CUR_VERSION=$(</etc/workshopbox/version)

echo 'Checking cookbook workshopbox for newer version...'
cd ~/.wsbox/cookbooks/chef-workshopbox
git pull

AVAIL_VERSION=$(cat metadata.rb | grep version | sed -e 's;^[^0-9]*\([0-9.]*\)[^0-9.]*$;\1;')

echo "Current Version:   ${CUR_VERSION}"
echo "Available Version: ${AVAIL_VERSION}"
vercomp "${CUR_VERSION}" "${AVAIL_VERSION}"
if [ $? -eq 2 -o $OPTION_FORCE -eq 1 ];then
  echo "Updating Workshopbox to Version ${AVAIL_VERSION}..."
  mofa provision . --verbose -T localhost -o 'workshopbox::default'
else
  echo "Workshopbox is already up to date."
fi

cd $OLDDIR
