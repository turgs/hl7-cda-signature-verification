#!/bin/bash
# this just checks the document signature matches that in the signature file, not the integrity of the signature itself

# Environment variables
SIGNATURE_FILE=""
CDA_DOCUMENT=""
EXECUTABLE=$0

# Print error message
function print_error {
    echo -e "\e[31mError:\e[0m $1"
}

# Print helper message
function print_helper {
    echo "Usage: $EXECUTABLE <CDA Document> <Signature File>"
}

# Read arguments
function read_arguments {
    [[ $# != 2 ]] && 
        print_error "Wrong argument list" &&
        print_helper &&
        exit 1
    CDA_DOCUMENT=$1
    SIGNATURE_FILE=$2
}

# Get document signature
function get_doc_signature {
    local tmp=`cat $SIGNATURE_FILE \
        | tr '\n' ' ' \
        |  grep -o '<q1:eSignature.*</q1:eSignature' \
        | grep -o '<DigestValue.*</DigestValue' \
        | grep -o '>\s*[A-Za-z0-9+/=\s]\+\s*<'`
    echo ${tmp:1:-1}
}

# Encode and return CDA signature
function get_actual_signature {
    cat $CDA_DOCUMENT | openssl dgst -binary -sha1 | openssl base64
}

# Main functionality
function main {
    read_arguments $@
    doc_signature=`get_doc_signature`
    expected_signature=`get_actual_signature`
    if [[ $doc_signature == $expected_signature  ]]; then
        echo -e "\e[32mSignature check PASSED\e[0m"
        exit 0
    else 
        echo -e "\e[31mSignature check FAILED\e[0m"
        exit 1
    fi
}

main $@
