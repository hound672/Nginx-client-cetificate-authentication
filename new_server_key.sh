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

# Create the Server Key, CSR, and Certificate
openssl genrsa -des3 -out $SSL_PRIVATE_DIR/server.key 2048
openssl req -new -key $SSL_PRIVATE_DIR/server.key -out $SSL_PRIVATE_DIR/server.csr

# Remove the necessity of entering a passphrase for starting up nginx with SSL using the private key
cp $SSL_PRIVATE_DIR/server.key $SSL_PRIVATE_DIR/server.key.org
openssl rsa -in $SSL_PRIVATE_DIR/server.key.org -out $SSL_PRIVATE_DIR/server.key

# We're self signing our own server cert here.  This is a no-no in production.
openssl x509 -req -days 1095 -in $SSL_PRIVATE_DIR/server.csr -CA $SSL_CERTS_DIR/ca.crt -CAkey $SSL_PRIVATE_DIR/ca.key -set_serial 02 -out $SSL_CERTS_DIR/server.crt
