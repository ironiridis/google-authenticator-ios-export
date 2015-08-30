#!/bin/bash

# get the keychain string from the user
KEYCHAIN_VALUE="$( echo "$1" | tr a-z A-Z | tr -dC 0-9A-Z )"

# via: https://github.com/google/google-authenticator/blob/6d436cfc7957cd519e3e79da146b1f7b20945adc/mobile/ios/Classes/OTPAuthURL.m#L40
BASE32_LOOKUP="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

# given a list of space-separated values, print corresponding base32 symbol
AWKPGM="{for(g=1;g<=NF;g++){printf(\"%s\",substr(\"$BASE32_LOOKUP\",\$g,1));}}"

# re-encode hex string into base32 symbol sequence
SEQUENCE="$(echo obase=32\; ibase=16\; $KEYCHAIN_VALUE | BC_LINE_LENGTH=400 bc)"
B32_STRING="$(echo $SEQUENCE | awk -F " " "$AWKPGM")"

if which -s qrencode
  then
    echo "Scan this QR with your new Google Authenticator app:"
    qrencode -t ANSI256 "otpauth://totp/x?secret=$B32_STRING"
    qrencode -t PNG -o $B32_STRING\ qr.png "otpauth://totp/x?secret=$B32_STRING"
    echo "This QR code has also been saved as $PWD/$B32_STRING qr.png"
    open $B32_STRING\ qr.png
  else
    echo "Cannot locate QR Encoder application."
    echo "You will need to encode this string into a QR code:"
    echo "otpauth://totp/x?secret=$B32_STRING"
    echo "Then scan it with your new Google Authenticator app."
fi
