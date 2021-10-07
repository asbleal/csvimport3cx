# csvimport3cx

Main Goal: 
Automation of uploading a contactlist in csv format to a 3CX appliance.

Reason:
3CX has no feature implemented to upload a contactlist as csv. Only a connection to multiple CRM-systems.
For people like me, which like open formats like "vcf" and organized their contactmanagement this way, there is no other option than to do it manually.


Using it:

The script needs "curl" to work, please install it yourself. 
It also will write a file called "cookies.txt" to save the session details.
I recommend to put all together in a folder.

Download the csvimport3cx.sh file, change the fields to your needs, make it executable and run it manually or via crontab.

Search in the script for the following fields:
Domain of your appliance: "your.3cx.domain"
Administrator-Username: "YOURUSERNAME"
Administrator-Password: "YOURPASSWORD"
Path to your Csvfile: "contacts.csv"



I hope you can use it to make your life easier. :)
Best Regards, 
Alex
