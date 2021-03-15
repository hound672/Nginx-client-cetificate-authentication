#!/bin/bash

function usage () {
        echo "$0 [CA section name] [username]"
        exit 1
}

if [ $# -ne 2 ]
then
        usage
fi

CA_NAME="$1"
USERNAME="$2"

SSL_DIR="/etc/ssl"
SSL_PRIVATE_DIR="$SSL_DIR/${CA_NAME}/private"
SSL_CERTS_DIR="$SSL_DIR/${CA_NAME}/certs"
USERS_DIR="${SSL_CERTS_DIR}/users"

mkdir -p ${USERS_DIR}

# Sign the client certificate with our CA cert.  Unlike signing our own server cert, this is what we want to do.
openssl x509 -req -days 1095 -in ${USERS_DIR}/${USERNAME}.csr -CA $SSL_CERTS_DIR/ca.crt -CAkey $SSL_PRIVATE_DIR/ca.key -CAserial $SSL_DIR/${CA_NAME}/serial -CAcreateserial -out ${USERS_DIR}/${USERNAME}.crt
