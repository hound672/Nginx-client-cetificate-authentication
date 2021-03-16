#!/bin/bash

function usage () {
        echo "$0 [username]"
        exit 1
}

if [ $# -ne 1 ]
then
        usage
fi

USERNAME="$1"

# Create the Client Key and CSR
openssl genrsa -aes256 -out ${USERNAME}.key 4096
openssl req -new -key ${USERNAME}.key -out ${USERNAME}.csr

