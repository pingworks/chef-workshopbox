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

# Access Username per convention:
WORKSHOP_ACCESSUSER=secret-${WORKSHOP_NAME}

cp .buildstep1.kitchen.local.yml .kitchen.local.yml
sed -i "s/__WORKSHOP_NAME__/${WORKSHOP_NAME}/g; s/__WORKSHOP_ACCESSUSER__/${WORKSHOP_ACCESSUSER}/g" .kitchen.local.yml
kitchen converge

cp .buildstep2.kitchen.local.yml .kitchen.local.yml
sed -i "s/__WORKSHOP_NAME__/${WORKSHOP_NAME}/g; s/__WORKSHOP_ACCESSUSER__/${WORKSHOP_ACCESSUSER}/g" .kitchen.local.yml
kitchen converge --log-level=debug
kitchen verify
