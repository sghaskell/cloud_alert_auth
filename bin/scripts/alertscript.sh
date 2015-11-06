# $SPLUNK_HOME/bin/scripts/echo.sh
# simple script that writes parameters 0-7 to 
# $SPLUNK_HOME/bin/scripts/echo_output.txt 
# $SPLUNK_ARG_0 and $0 show how to use the long and short form. 

# Modify to fit your environment
CREDENTIAL_USER="shaskell"
# Set realm if entered with password
CREDENTIAL_REALM=""
# Update App Name
APP="cloud_alert_auth"
# Search needs to be owned by someone with admin rights to access passwords
ALERT_OWNER="admin"
# Splunk Host
SPLUNK_HOST="localhost"

# Splunk Python
SPLUNK_PYTHON="$SPLUNK_HOME/bin/splunk cmd python"

read sessionKey
key=`echo $sessionKey | sed s/sessionKey=//g`
decoded_key=`$SPLUNK_PYTHON -c "import sys, urllib as ul; print ul.unquote_plus('$key')"`
clear_password=`curl -s -k -H "Authorization: Splunk $decoded_key" https://$SPLUNK_HOST:8089/servicesNS/$ALERT_OWNER/$APP/storage/passwords/$CREDENTIAL_REALM:$CREDENTIAL_USER: | grep clear_password | sed -re 's/^\s+<s:.*?>(.*?)<.*?>$/\1/g'`
echo "$clear_password" >> /tmp/password.txt
