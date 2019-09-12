require 'rubygems'
require 'pp'
require_relative 'lib/loader'
require_relative 'lib/parser'
require_relative 'lib/detail_item'
require_relative 'lib/list_item'
require_relative 'lib/csv_worker'

#Loader is for GET and POST Request Handling
#Parser to extract informations and generating CSV
def get_list
    loader = Loader.new
    puts "Start"
    puts "Loading Applipedia List ..."
    list_html = loader.get_app_list
    parser = Parser.new(list_html)
    puts "Parsing..."
    result_array = parser.generate_list
    puts "Downloaded #{result_array.length} rows"
    puts "Generating Result..."
    CSVWorker.write_csv("applipedia_list.csv", result_array)
    puts "Finished!"
end

def get_details
    result = []
    cnt_max = 0
    cnt_current = 0
    loader = Loader.new
    puts "Start"
    list = CSVWorker.read_csv("applipedia_short_list")
    puts "loaded #{list.length} rows"
    puts "Downloading App Definitions"
    list.shift
    cnt_max = list.length
    list.each do |app|
        #(appId, appName, ottawagroup)
        id = app[0]
        name = app[1]
        ottawagroup = app[2]
        puts "App #{name} - #{cnt_current} / #{cnt_max}"
        detail_html = loader.get_app_detail(id, name, ottawagroup)
        parser = Parser.new(detail_html)
        item = parser.get_details(id, name)
        result << item
        #sleep(1)
        cnt_current += 1
    end
    puts "Generating Result..."
    #pp result
    code = CSVWorker.write_csv("applipedia_detail_list.csv", result)
    puts "Finished with #{code}"
end

#Gernate the App List (applipedia_list.csv)
#get_list
#Generate the Full Detail CSV (applipedia_detail_list.csv)
#I recommend to test the functionality with a "short list" - applipedia_short_list
#get_details


#Example Requests for differnet app details (only length 14 - no Characteristics)
#loader = Loader.new
#puts loader.get_app_detail("693", "asf-streaming", "0")
#only text and description
#puts loader.get_app_detail("165", "2ch", "1")
#full details
#puts loader.get_app_detail("572", "4shared", "0")

#item = loader.get_app_detail("572", "4shared", "0")
#parser = Parser.new(item)
#pp parser.get_details("572")