#!/bin/bash
set -e
set +x

if [ ! -f .kitchen.yml ]; then
  echo "Please cd into the actual cookbook folder!"
  exit 1
fi

echo "ATTENTION:"
echo "Make sure that you have a real - able to access secret server - id_rsa in folder files/default of this cookbook!"
echo

WORKSHOP_NAME=$1
if [ -z "$WORKSHOP_NAME" ];then
  echo "ARG1 missing. Please specify Workshop Name like 'clc2015'."
  exit 1
fi

EXPORT_APPLIANCE=0
if [ -n "$2" ];then
  EXPORT_APPLIANCE=1
fi

cp .buildstep1.kitchen.local.yml .kitchen.local.yml
sed -i -e "s/__WORKSHOP_NAME__/${WORKSHOP_NAME}/g" .kitchen.local.yml
kitchen converge

cp .buildstep2.kitchen.local.yml .kitchen.local.yml
sed -i -e "s/__WORKSHOP_NAME__/${WORKSHOP_NAME}/g" .kitchen.local.yml
kitchen converge
kitchen verify

if [ $EXPORT_APPLIANCE -eq 1 ];then

fi
