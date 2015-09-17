var express = require('express');
var app = express();
var bodyParser = require('body-parser')
var changeCase = require("change-case");

fs = require('fs')

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

app.post('/subway', function (req, res) {

  fs.readFile('serviceStatus.txt', 'utf8', function (err,data) {
    var parseString = require('xml2js').parseString;

    parseString(data, function (err, result) {
      //console.log(result);
      if (err) {
        return console.log(err);
      }

      if (req.body.request.intent != undefined) {
        console.log("query: ",req.body.request.intent.name);
      }
  
      console.log("Got request: %o", req.body);

      say_this = "";

      if (req.body.request.intent == undefined || req.body.request.intent.name == "GetAllStatus") {
        for (var i=0; i<result["service"]["subway"][0]["line"].length;i++) {
          line = result["service"]["subway"][0]["line"][i];
          say_this = say_this.concat(line["name"][0].replace(/(\S{1})/g,"$1 "))
          say_this = say_this.concat("line has ")
          say_this = say_this.concat(line["status"][0])
          say_this = say_this.concat(", ")
        }

      } else if (req.body.request.intent.name == "GetStatus") {
	line_suspected = changeCase.upperCase(req.body.request.intent.slots.Line.value).replace(/ /g,'') //uppercase, remove whitespace
        
        console.log("BINGO:", req.body.request.intent.slots)
        for (var i=0; i<result["service"]["subway"][0]["line"].length;i++) {
          line = result["service"]["subway"][0]["line"][i]
	  line_name = line["name"][0]
          if (line_suspected == "ONE") line_suspected = 1
          if (line_suspected == "TWO") line_suspected = 2
          if (line_suspected == "THREE") line_suspected = 3
          if (line_suspected == "FOUR" || line_suspected == "FOR") line_suspected = 4
          if (line_suspected == "FIVE") line_suspected = 5
          if (line_suspected == "SIX") line_suspected = 6
          if (line_suspected == "SEVEN") line_suspected = 7
          if (line_suspected == "EIGHT") line_suspected = 8
          if (line_suspected == "NINE") line_suspected = 9 
            console.log("comparing", line_suspected, "with", line_name)
          if (line_name.indexOf(line_suspected) > -1) {
            say_this = say_this.concat("The ")
            say_this = say_this.concat(line_name.replace(/(\S{1})/g,"$1 "))
            say_this = say_this.concat("line has ")
            say_this = say_this.concat(line["status"][0])
            say_this = say_this.concat(", ")
          } 
        }

	if (say_this == "")
          say_this = "I'm not sure what subway line you're asking about. At the moment, I can not understand letters. I can only understand numbers. Please put in a feature request for Alexa to understand letters."
      } 

      console.log("say this is:", say_this)

    text = {"outputSpeech": {"type": "PlainText", "text": say_this}}
    response = { 
      "version": "0.1", 
//    "sessionAttributes": { "someInfoOnPreviousRequest": { "last_line": "something"   } },
      "response": text,
      "shouldEndSession": true  
    } 

    console.log("Sending response: ", JSON.stringify(response))
    res.send(JSON.stringify(response));
 
    });
  });
});

var server = app.listen(4445, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('alexa-nyc-mta skill listening at http://%s:%s', host, port);
});

