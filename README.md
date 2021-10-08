# csvimport3cx

## Main Goal
Automation of uploading a contactlist in csv format to a 3CX appliance.

## Reason
3CX has no feature implemented to upload a contactlist as csv. Only a connection to multiple CRM-systems.
For people like me, which like open formats like "vcf" and organized their contactmanagement this way, there is no other option than to do it manually.


## Requirements

The script needs `curl` to work, please install it yourself.

## Usage

Download `csvimport3cx.sh` and `csvimport3cx.conf-template`. Rename this last
one to `csvimport3cx.conf` and adjust values to your setup.

By default the script will import the file `contacts.csv` located in the same directory
of the script. This can be overridden by passing `-f` option to the script.

## Sample run

```
# ./csvimport3cx.sh
Logging in
Deleting all contatcs
Importing ./contacts.csv
{"importCount":713,"ErrorLines":[],"WarningLines":[],"Exception":null,"success":true,"nowarnings":true}
```

## Greetings
I hope you can use it to make your life easier. :)
Best Regards.

## Authors

* Alex (@asbleal)
* @maxxer
