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

echo "Running mofa provison..."
mofa provision . -T localhost -o 'workshopbox::update_wsbox_doc'

cd $OLDDIR

# clear firefox cache
if [ -d ~/.cache/mozilla/firefox/workshop ];then
  rm -rf ~/.cache/mozilla/firefox/workshop
fi
