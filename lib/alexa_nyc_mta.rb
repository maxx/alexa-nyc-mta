
MTA_STATUS_FILE = "serviceStatus.txt"

class AlexaNYCMTA

   def initialize
     f = File.open("serviceStatus.txt", "r")
     @doc = Nokogiri::XML(f)
     f.close
   end
 
   def name
     @doc.xpath("//name").collect do |name|
       name.children.text
     end
   end
 
   def status
    @doc.xpath("//status").collect do |status|
       status.children.text
     end
   end
 
   def subway_status
     name.zip(status)[0..10]
   end

end

