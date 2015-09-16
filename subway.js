var express = require('express');
var app = express();
fs = require('fs')


app.post('/subway', function (req, res) {
  fs.readFile('serviceStatus.txt', 'utf8', function (err,data) {
    var parseString = require('xml2js').parseString;

    parseString(data, function (err, result) {
      //console.log(result);
      if (err) {
        return console.log(err);
      }
      console.log("query: ",req.query);
  
      console.log("Got request: %o", req);

      say_this = "";

      for (var i=0; i<result["service"]["subway"][0]["line"].length;i++) {
        line = result["service"]["subway"][0]["line"][i];
        say_this = say_this.concat(line["name"][0].replace(/(\S{1})/g,"$1 "))
        say_this = say_this.concat("line has ")
        say_this = say_this.concat(line["status"][0])
        say_this = say_this.concat(", ")
      };

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

