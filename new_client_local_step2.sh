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

echo "making p12 file"
#browsers need P12s (contain key and cert)
openssl pkcs12 -export -clcerts -in ${USERNAME}.crt -inkey ${USERNAME}.key -out ${USERNAME}.p12

echo "made ${USERNAME}.p12"
