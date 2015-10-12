#!/bin/bash
OLDDIR=$(pwd)
set -e

if [ "$EUID" -eq 0 ]
  then echo "Please DO NOT run as root!"
  exit
fi

echo 'Updating cookbook workshopbox...'
cd ~/.wsbox/cookbooks/chef-workshopbox
git pull

echo "Running mofs provison..."
mofa provision . --verbose --debug -T localhost -o 'workshopbox::update-wsbox-tools'

cd $OLDDIR
