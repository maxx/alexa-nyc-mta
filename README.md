# Amazon Alexa NYC MTA Status Skill - NYC Subway Status on Amazon Echo (Alexa!)


This is a simple alexa skill which will allow you to query the status of NYC MTA transport.

Currently, it only supports the NYC subway.

# Utterance examples:

Alexa, ask subway status of all lines
Alexa, ask subway status of [the] 7 line
Alexa, ask subway status of [the] A C E lines

# Running

The script updates off the MTA ServiceStatus "text file" "html-inside-xml" mess 
on the mta.info website at http://web.mta.info/status/serviceStatus.txt.

A crontab entry is necessary to pull down serviceStatus.txt every 5 minutes from 

*/5 * * * * curl http://web.mta.info/status/serviceStatus.txt > /home/maxx/alexa_nyc_subway/serviceStatus.txt

And simply run "nodejs subway.js" via upstart or you preferred method.

# Nginx

Alexa skills API will only reach a service on https with a signed or self-signed (providec) certificate.  Use the included example nginx virtual-host configuration to proxy to nodejs.

