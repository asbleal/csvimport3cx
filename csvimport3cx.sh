#!/bin/sh

CONFIGFILE="$(dirname $0)""/csvimport3cx.conf"

if [ ! -f "$CONFIGFILE" ]; then
  echo "Missing config file $CONFIGFILE"
  exit 1;
fi

source $CONFIGFILE
URL3CX="https://$HOST3CX"
echo $URL3CX

echo "Logging in"
curl "$URL3CX/api/login" \
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
                -H "referer: $URL3CX" \
                -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
                --data-raw "{'Username':""$USERNAME"", 'Password':""$PASSWORD""}" \
                --compressed -c cookies.txt -b cookies.txt

echo $?
echo "Deleting contatcs"
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
                -H "referer: $URL3CX" \
                -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
                --data-raw '{}' --compressed -c cookies.txt -b cookies.txt

echo $?
echo "Importing contacts.csv"
curl "$URL3CX/api/PhoneBookEntryList/import" \
                --form fileInput=@contacts.csv \
                --form press=submit \
                -b cookies.txt -c cookies.txt

echo "Done"
echo $?
exit $?
