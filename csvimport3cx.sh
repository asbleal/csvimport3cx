#!/bin/sh

! which "curl" >/dev/null && echo "Error: \"curl\" not found or executable" && exit 1

CONFIGFILE="$(dirname $0)""/csvimport3cx.conf"
if [ ! -f "$CONFIGFILE" ]; then
  echo "Missing config file $CONFIGFILE"
  exit 1;
fi

. $CONFIGFILE

CONTACTS_FILENAME="$(dirname $0)""/contacts.csv"
# Params parsing
while [[ $# -gt 0 ]]; do
  case "$1" in
    # flow-modifying parameters
    -f|--file-name)
      [ -z "$2" ] && echo "Missing contacts file name argument" && exit 1
      CONTACTS_FILENAME=$2
      shift
      ;;
    *)
      echo "Unknown option: $1." >& 2
      exit 1
      ;;
  esac
  shift
done
if [ ! -f "$CONTACTS_FILENAME" ]; then
  echo "Contacts CSV '$CONTACTS_FILENAME' not found"
  exit 1;
fi

TEMPDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")
COOKIESFILENAME="$TEMPDIR/cookies.txt"

echo "Logging in"
LOGIN=$(curl "$URL3CX/api/login" \
                -H "authority: $HOST3CX" \
                -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="92"' \
                -H 'accept: application/json, text/plain, */*' \
                -H 'sec-ch-ua-mobile: ?0' \
                -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.134 Safari/537.36' \
                -H 'content-type: application/json;charset=UTF-8' \
                -H "origin: $URL3CX" \
                -H 'sec-fetch-site: same-origin' \
                -H 'sec-fetch-mode: cors' \
                -H 'sec-fetch-dest: empty' \
                -H "referer: $URL3CX/" \
                -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
                --silent \
                --data-raw "{'Username':'$USERNAME', 'Password':'$PASSWORD'}" \
                --compressed -c $COOKIESFILENAME -b $COOKIESFILENAME)

if [ ! "$LOGIN" == "AuthSuccess" ]; then
  echo "Login failed: $LOGIN"
  exit 2
fi

echo "Deleting all contatcs"
curl "$URL3CX/api/PhoneBookEntryList/deleteAll" \
                -H "authority: $HOST3CX" \
                -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="92"' \
                -H 'accept: application/json, text/plain, */*' \
                -H 'sec-ch-ua-mobile: ?0' \
                -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.134 Safari/537.36' \
                -H 'content-type: application/json;charset=UTF-8' \
                -H "origin: $URL3CX" \
                -H 'sec-fetch-site: same-origin' \
                -H 'sec-fetch-mode: cors' \
                -H 'sec-fetch-dest: empty' \
                -H "referer: $URL3CX/" \
                -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
                --silent \
                -o /dev/null \
                --data-raw '{}' --compressed -c $COOKIESFILENAME -b $COOKIESFILENAME

echo "Importing $CONTACTS_FILENAME"
curl "$URL3CX/api/PhoneBookEntryList/import" \
                --form fileInput=@$CONTACTS_FILENAME \
                --form press=submit \
                -b $COOKIESFILENAME -c $COOKIESFILENAME

rm $COOKIESFILENAME
rmdir $TEMPDIR

exit $?
