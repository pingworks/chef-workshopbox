#!/bin/bash

USERNAME="$1"
if [ -z "$USERNAME" ]; then
  echo "Usage $0 <username>"
  exit 1
fi

set -e

CADIR="/etc/kubernetes/pki"
[ -e ${CADIR}/${USERNAME}-key.pem ] || openssl genrsa -out ${CADIR}/${USERNAME}-key.pem 2048
[ -e ${CADIR}/${USERNAME}.csr ] || openssl req -new -key ${CADIR}/${USERNAME}-key.pem -out ${CADIR}/${USERNAME}.csr -subj "/CN=${USERNAME}"
[ -e ${CADIR}/${USERNAME}.pem ] || openssl x509 -req -in ${CADIR}/${USERNAME}.csr -CA ${CADIR}/ca.crt -CAkey ${CADIR}/ca.key -CAcreateserial -out ${CADIR}/${USERNAME}.pem -days 365

TEMP=$(mktemp -d)
KUBEDIR=${TEMP}/.kube
mkdir $KUBEDIR
SERVER=$(grep server: /etc/kubernetes/admin.conf | awk '{print $2}')
CLUSTER=$(grep cluster: /etc/kubernetes/admin.conf | grep -v '^-' | head -n 1 | awk '{print $2}')
cat << EOF > ${KUBEDIR}/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: ca.crt
    server: $SERVER
  name: $CLUSTER
contexts:
- context:
    cluster: $CLUSTER
    user: $USERNAME
  name: ${USERNAME}@${CLUSTER}
current-context: ${USERNAME}@${CLUSTER}
kind: Config
preferences: {}
users:
- name: $USERNAME
  user:
    client-certificate: ${USERNAME}.pem
    client-key: ${USERNAME}-key.pem
EOF
cp ${CADIR}/${USERNAME}-key.pem ${KUBEDIR}/
cp ${CADIR}/${USERNAME}.pem ${KUBEDIR}/
cp ${CADIR}/ca.crt ${KUBEDIR}/
cd $TEMP
zip -q /root/${USERNAME}-config.zip .kube/*
rm -rf $TEMP

echo "Key in: ${CADIR}/${USERNAME}-key.pem"
echo "Cert in: ${CADIR}/${USERNAME}.pem"
echo "Config in /root/${USERNAME}-config.zip"
