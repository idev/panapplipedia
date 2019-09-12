require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'json'
require 'pp'
require 'httparty'

class Loader
    APPLIPEDIA_LIST_VIEW = "https://applipedia.paloaltonetworks.com/Home/GetApplicationListView"
    APPLIPEDIA_APP_DETAILS = "https://applipedia.paloaltonetworks.com/Home/GetApplicationDetailView"

    REQUEST_HEADER = {"Accept" => "*/*",
    "DNT" =>  "1",
    "Connection" => "keep-alive",            
    "Content-Type"=> "application/x-www-form-urlencoded",
    "Accept-Language" => "en-US,en;q=0.9",
    "Accept-Encoding" => "gzip, deflate, br",
    "Host" => "applipedia.paloaltonetworks.com",
    "Origin" => "https://applipedia.paloaltonetworks.com",
    "Referer" => "https://applipedia.paloaltonetworks.com/",
    "User-Agent"=> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
    "X-Requested-With" =>  "XMLHttpRequest" }

    def initialize
    end

    # Get Request for List
    def get_app_list
        doc = Nokogiri::HTML(open(APPLIPEDIA_LIST_VIEW,REQUEST_HEADER))
        return doc
    end
    # POST Request for Details
    # for debug add  :debug_output => $stdout to post request
    def get_app_detail(appId, appName, ottawagroup)
        res = HTTParty.post(APPLIPEDIA_APP_DETAILS,
            {
                :body => "id=#{appId}&ottawagroup=#{ottawagroup}&appName=#{appName}" ,
                :headers => {"Accept" => "*/*",
                "DNT" =>  "1",
                "Connection" => "keep-alive",            
                "Content-Type"=> "application/x-www-form-urlencoded",
                "Accept-Language" => "en-US,en;q=0.9",
                "Accept-Encoding" => "gzip, deflate, br",
                "Host" => "applipedia.paloaltonetworks.com",
                "Origin" => "https://applipedia.paloaltonetworks.com",
                "Referer" => "https://applipedia.paloaltonetworks.com/",
                "User-Agent"=> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
                "X-Requested-With" =>  "XMLHttpRequest" }
            })
        #pp res.request.last_uri.to_s
        return Nokogiri::HTML(res)
    end

end