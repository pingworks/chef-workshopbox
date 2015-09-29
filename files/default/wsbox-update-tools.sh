#!/bin/bash
OLDDIR=$(pwd)

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo 'Updating cookbook ws-workshopbox...'
cd /opt/workshopbox/lib/cookbooks/chef-ws-workshopbox
git pull

echo "Running mofs provison..."
mofa provision . -T localhost -o 'ws-workshopbox::update-wsbox-tools'

cd $OLDDIR
