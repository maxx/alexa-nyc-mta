# Amazon Alexa NYC MTA Status Skill - NYC Subway Status on Amazon Echo (Alexa!)


This is a simple alexa skill which will allow you to query the status of NYC MTA transport.

Currently, it only supports the NYC subway.

# Amazon Feedback / Requirements

Working spreadsheeet: https://docs.google.com/spreadsheets/d/15goECEyoLIs8mYvrAC25RZyRWwUqew7zgBiLMiux2A8

# Utterance examples:

Current:

Alexa, open subway

Alexa, ask subway about all lines

Soon:

(Currently, alexa cannot reconize letters - only words.. so might have to do some lexical analysis on things e.g. "for" -> 4.)

Alexa, ask subway to get status of [the] 7 line

Alexa, ask subway to get status of [the] A C E lines

Todo: 

* Break subway data into model/class
* Add support for invidual lines again using keywords, like "ace" for A C E, as Alexa can't hear individual letters currently.

# Running

The script updates off the MTA ServiceStatus "text file" "html-inside-xml" mess 
on the mta.info website at http://web.mta.info/status/serviceStatus.txt.

A crontab entry is necessary to pull down serviceStatus.txt every 5 minutes from 

*/5 * * * * curl http://web.mta.info/status/serviceStatus.txt > /home/maxx/alexa_nyc_subway/serviceStatus.txt

Simply run "ruby subway.rb" to sample or run in passenger or your favorite app server.

# Nginx

Alexa skills API will only reach a service on https with a signed or self-signed (providec) certificate.  Use the included example nginx virtual-host configuration to proxy to nodejs.

* Not Affiliated with the New York City MTA

This skill and its creator are not in any way affiliated with the NYC MTA.
