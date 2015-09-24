# subway.rb - alexa nyc mta subway 
#

require 'sinatra'
require 'nokogiri'
require 'json'

require_relative 'lib/alexa_nyc_mta'


post '/subway' do 
   begin
       subway = AlexaNYCMTA.new 
       status = subway.subway_status
       
       request_body = JSON.parse request.body.read
       puts request_body
       puts "subway #{status}"
       intent = request_body["request"]["intent"]["name"]
       puts "intent #{intent}"
       say_this = ""
       if (intent == "GetAllStatus")
         say_this = "yo hey what's up aww hell no"
     
       else
     
         say_this = "yo hey what's up aww hell no"
         
       end

   rescue
         say_this = "yo hey what's up aww hell no"

   end 
   text = {"outputSpeech" => {"type" => "PlainText", "text" => say_this}}
   response = {
       "version" => "0.2",
       "sessionAttributes" => { "someInfoOnPreviousRequest" => { "last_line" => "something" } },
        "response" => text,
        "shouldEndSession" => true
   } 
 
   puts "response: #{response.to_json}"
 
   response.to_json
end


