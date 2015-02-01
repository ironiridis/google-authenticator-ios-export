#!/bin/bash

# get the keychain string from the user
KEYCHAIN_VALUE="$( echo "$1" | tr a-z A-Z | tr -dC 0-9A-Z )"

# via: https://github.com/google/google-authenticator/blob/6d436cfc7957cd519e3e79da146b1f7b20945adc/mobile/ios/Classes/OTPAuthURL.m#L40
BASE32_LOOKUP="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

# given a list of space-separated values, print corresponding base32 symbol
AWKPGM="{for(g=1;g<=NF;g++){printf(\"%s\",substr(\"$BASE32_LOOKUP\",\$g,1));}}"

# re-encode hex string into base-32 symbol sequence
SEQUENCE="$(echo obase=32\; ibase=16\; $KEYCHAIN_VALUE | BC_LINE_LENGTH=400 bc)"
B32_STRING="$(echo $SEQUENCE | awk -F " " "$AWKPGM")"

echo $B32_STRING
