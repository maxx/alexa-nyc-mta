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
       puts "request body is #{request_body}"
#       puts "subway #{status}"
       intent = request_body["request"]["intent"]["name"] if request_body["request"]["intent"]
       puts "intent #{intent}"
       say_this = ""
       if (intent == "GetAllStatus" || intent == nil)
          say_this = "ok. hold on... "
          delayed_lines = status.select { |key, value| value.match("DELAYS")}.transpose[0]
          planned_work_lines = status.select { |key, value| value.match("PLANNED WORK")}.transpose[0]
          if (delayed_lines && (delayed_lines.count > 0 || planned_work_lines.count > 0))
              #puts "delayed_lines count is #{delayed_lines.count}"
              if (delayed_lines.count > 0)
                 if (delayed_lines.count == 1)
                    delayed_line = delayed_lines[0].gsub(/(.{1})/, '\1 ')
                    say_this << "The #{delayed_line} is currently experiencing delays. " 
                 else
                    delayed_lines.each do |delayed_line| 
                       delayed_line = delayed_line.gsub(/(.{1})/, '\1 ')
                       say_this << "The #{delayed_line} is currently experiencing delays.  " 
                    end
                 end
              end
              if (planned_work_lines.count > 0)
                 if (planned_work_lines.count == 1)
                    planned_work_line = planned_work_lines[0].gsub(/(.{1})/, '\1 ')
                    say_this << "The #{planned_work_line} is currently undergoing planned work.  " 
                 else
                    planned_work_lines.each do |planned_work_line| 
                       planned_work_line = planned_work_line.gsub(/(.{1})/, '\1 ')
                       say_this << "The #{planned_work_line} is currently undergoing planned work.  " 
                    end
                 end
              end
          else
              say_this << "All lines are currently running smoothly."
          end
          
          puts "delayed lines are #{delayed_lines}"
          #say_this = "The #{delayed_lines}" 
       else
     
         say_this = "I can't do status of individual lines yet in this version"
         
       end

#   rescue
#      say_this = "rut roh. something failed"

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


