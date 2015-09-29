#!/bin/bash

# wrapper for berks cookbook
echo "This is just a wrapper around the command:"
echo "berks cookbook $1"

berks cookbook $1

echo
echo "Now tweaking some minor details..."
echo "Renaming folder $1 to chef-$1 to fulfill naming conventions."
mv $1 "chef-$1"
echo "Deleting unneccessary files..."
rm -v "chef-$1/Thorfile"
rm -v "chef-$1/Vagrantfile"

echo "Tweaking .kitchen.yml driver (kitchen-docker)..."
sed -e "s;__COOKBOOK__;$1;g" /opt/workshopbox/lib/tpl/.kitchen.yml.tpl > "chef-$1/.kitchen.yml"
echo "Done."
echo
echo "Please find your fresh & empty cookbook here:"
echo "cd ./chef-$1"
echo
echo "kitchen create (to create a new empty test vm)"
echo "kitchen converge (to apply your recipes to the test vm)"
echo "kitchen verify (to run the infrastructure tests)"
echo "kitchen destroy (to throw awqay the test vm)"
echo "kitchen login (to log into the test vm)"
