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
          good_lines = status.select { |key, value| value.match("GOOD SERVICE")}.transpose[0]
          delayed_lines = status.select { |key, value| value.match("DELAYS")}.transpose[0]
          planned_work_lines = status.select { |key, value| value.match("PLANNED WORK")}.transpose[0]
          service_change_lines = status.select { |key, value| value.match("SERVICE CHANGE")}.transpose[0]
          puts "good lines are #{good_lines}"
          if (delayed_lines || planned_work_lines || service_change_lines)
             say_this = "ok. here's the situation... "
             if (delayed_lines && delayed_lines.count > 0)
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
             if (planned_work_lines && planned_work_lines.count > 0)
                puts "planned_work_lines are #{planned_work_lines}"
                if (planned_work_lines.count == 1)
                   planned_work_litne = planned_work_lines[0].gsub(/(.{1})/, '\1 ')
                   say_this << "The #{planned_work_line} is currently undergoing planned work.  " 
                else
                   planned_work_lines.each do |planned_work_line| 
                      planned_work_line = planned_work_line.gsub(/(.{1})/, '\1 ')
                      say_this << "The #{planned_work_line} is currently undergoing planned work.  " 
                   end
                end
             end
             if (service_change_lines && service_change_lines.count > 0)
                if (service_change_lines.count == 1)
                   service_change_litne = service_change_lines[0].gsub(/(.{1})/, '\1 ')
                   say_this << "The #{service_change_line} has a major service change.  " 
                else
                   service_change_lines.each do |service_change_line| 
                      service_change_line = service_change_line.gsub(/(.{1})/, '\1 ')
                      say_this << "The #{service_change_line} has a major service change.  " 
                   end
                end
             end

             say_this << "All other lines are currently running smoothly."
          else
             say_this = "ok. Great news. "
             say_this << "All lines are currently running smoothly."
          end
          
          #say_this = "The #{delayed_lines}" 
       else
     
         say_this = "I can't do status of individual lines yet. Please check back in a few days."
         
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


