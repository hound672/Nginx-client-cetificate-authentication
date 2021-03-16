#!/bin/bash

function usage () {
	echo "$0 [CA section name]"
	exit 1
}

if [ $# -ne 1 ]
then
	usage
fi

CA_NAME="$1"

SSL_DIR="/etc/ssl"
SSL_PRIVATE_DIR="$SSL_DIR/${CA_NAME}/private"
SSL_CERTS_DIR="$SSL_DIR/${CA_NAME}/certs"
SSL_CRL_DIR="$SSL_DIR/${CA_NAME}/crl"

mkdir -p ${SSL_PRIVATE_DIR}
mkdir -p ${SSL_CERTS_DIR}
mkdir -p ${SSL_CRL_DIR}

touch $SSL_DIR/${CA_NAME}/index.txt
echo 01 > $SSL_DIR/${CA_NAME}/crlnumber

# Create the CA Key and Certificate for signing Client Certs (good for 3 yrs)
openssl genrsa -aes256 -out $SSL_PRIVATE_DIR/ca.key 4096
openssl req -new -x509 -days 1095 -key $SSL_PRIVATE_DIR/ca.key -out $SSL_CERTS_DIR/ca.crt

# Create a Certificate Revocation list for removing 'user certificates.'
openssl ca -name ${CA_NAME} -gencrl -keyfile $SSL_PRIVATE_DIR/ca.key -cert $SSL_CERTS_DIR/ca.crt -out $SSL_PRIVATE_DIR/ca.crl -crldays 1095
