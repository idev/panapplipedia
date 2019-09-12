require 'rubygems'
require 'nokogiri'
require 'pp'
require 'csv'

class Parser

    @doc
    @list_array

    def initialize(document)
        @doc = document
        @list_array = []
    end

    def generate_list
        table = @doc.search("#dataTable")
        rows = table.search("tr")
        rows.each do |cell|
            item = ListItem.new
            #pp item
            #ShowApplicationDetail('2514', '24sevenoffice', '0'); return false;
            #Caution - the subclasses are in a deeper trunk
            #if cell.children[1].nil?
                if cell.children[1].children[3].nil?
                match_data = cell.children[1].children[1].attr("onclick").match /'(?<app_id>\d+)', '(?<name>.*)', '(?<otto>\d)'/
            else
                match_data = cell.children[1].children[3].attr("onclick").match /'(?<app_id>\d+)', '(?<name>.*)', '(?<otto>\d)'/
                end
            item.app_id = match_data[:app_id]
            item.name = match_data[:name]
            item.ottawagroup = match_data[:otto]
            #pp cell.children[2].inner_html.gsub(/\t+/, "")
            #category
            item.category = cell.children[3].text.gsub(/\s+/, "")
            #pp cell.children[4].inner_html.gsub(/\t+/, "")
            #subcategory
            item.subcategory = cell.children[5].text.gsub(/\s+/, "")
            #pp cell.children[6].inner_html.gsub(/\t+/, "")
            #Risk type from image title - only present withou subset of app-ids (ottawagroup != 0)
            unless cell.children[7].children.search("img").empty?
                item.risklevel = cell.children[7].children.search("img").attr("title").text
            end
            #technology
            item.technology = cell.children[9].text.gsub(/\s+/, "")
            #add all items to a array
            @list_array << item
        end
        return @list_array
    end
    #app id necessary for DetailItem Class
    def get_details(app_id, app_name)
        table = @doc.search(".popInfoPanelStyle")
        descr = table.search("div.idented")
        item = DetailItem.new
        item.app_id = app_id
        item.app_name = app_name
        #Description, Reference, Depends
        item.description = descr[0].inner_html.gsub(/\t+/, "").gsub(/\n+/, "").gsub(/\r+/, "").gsub(/\"+/, "")
        item.reference = descr[1].inner_html.gsub(/\t+/, "").gsub(/\n+/, "").gsub(/\r+/, "")
        #missing on LOW DETAILS
        unless descr[3].nil?
         item.depends = descr[2].inner_html.gsub(/\t+/, "").gsub(/\n+/, "")
        end
      
        text = table.search(".charvalue")
        #missing on LOW DETAILS
        unless text.empty?
          # "Category"
          item.category = text[0].text.strip!
          # "Evasive"
          item.evasive = text[1].text.strip!
          # "Subcategory"
          item.subcategory = text[2].text.strip!
          # "Excessive Bandwith"
          item.bandwith = text[3].text.strip!
          # "Risk"
          item.risk = text[4].search("img").attr("title").text
          # "Prone to missuse"
          item.misuse = text[5].text.strip!
          # "Standard Ports"
          item.ports = text[6].text.strip!
          # "Capable of File Transfer"
          item.file_transfer = text[7].text.strip!
          # "Technology"
          item.technology = text[8].text.strip!
          # "Tunnels other Applications"
          item.tunnel = text[9].text.strip!
          # "Used by Malware"
          item.malware = text[10].text.strip!
          # "Has known Vulnerabilities"
          item.known_vulnerabilities = text[11].text.strip!
          # "Widly used"
          item.widly_used = text[12].text.strip!
          # "SaaS"
          item.saas = text[13].text.strip!
          # "SaaS Characteristics" - not present every time - only for FULL DETAILS
          # "Certifications"
          if text.length > 14
              item.certifications = text[14].text.strip!
              # "Data Breaches"
              item.data_breach = text[15].text.strip!
              # "IP Based Restrictions"
              item.ip_based_restriction = text[16].text.strip!
              # "Poor Financial Viability"
              item.poor_financial_viability = text[17].text.strip!
              # "Poor Terms of Service	"
              item.poor_terms_of_service = text[18].text.strip!
          end
        end
      
        #pp item
        return item
    end
    #Array of ListItems or DetailItems
    def generate_csv(file_name, array_of_list_items)
        CSV.open(file_name, "wb") do |csv|
          #write header
          csv << array_of_list_items.first.attribute_names
          array_of_list_items.each do |item|
              csv << item.attribute_values
          end
        end
    end

end