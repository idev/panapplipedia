require 'rubygems'
require 'nokogiri'
require 'pp'
require 'csv'
require_relative '../lib/parser'

TEST_LIST = "test_list.txt"
SHORT_LIST = "list_test_small.txt"

LOW_DETAILS = "low_details_test.html"
MEDIUM_DETAILS = "medium_details_test.html"
FULL_DETAILS = "full_details_test.html"

PURIFY_TEST_HTML = "<a href=""http://www.100bao.com/"" target=""_blank"">www.100bao.com</a><a href=""http://www.google.com/search?q=100bao"" target=""_blank"">Google</a><a href=""http://search.yahoo.com/search?q=100bao"" target=""_blank"">Yahoo!</a>"
PURIFY_TEST_PORT = "tcp/3468,6346,11300"
PURIFY_TEST_DESC = "100bao (literally translated as ""100 treasures"") is a free Chinese P2P file-sharing program that supports Windows 98, 2000, and XP operating systems."

@doc = ""
@list_array = []

class ListItem
  attr_accessor :app_id, :name, :ottawagroup, :category, :subcategory, :risklevel, :technology

  def initialize
  end

  def self.attribute_names
    #id and app and not app_id, name are used because of matching with palo alto log
    return ["id", "app", "ottawagroup", "category", "subcategory", "risklevel", "technology"]
  end

  def attribute_values
    result = []
    result << @app_id
    result << @name
    result << @ottawagroup
    result << @category
    result << @subcategory
    result << @risklevel
    result << @technology
    return result
  end

end

class DetailItem
  attr_accessor :app_id, :description, :reference, :depends, :category, :evasive, :subcategory, :bandwith, :risk, :misuse, :ports, :file_transfer,
  :technology, :tunnel, :malware, :known_vulnerabilities, :widly_used, :saas, :certifications, :data_breach, :ip_based_restriction, :poor_financial_viability,
  :poor_terms_of_service

  def initialize
  end

  def self.attribute_names
    #id and app and not app_id, name are used because of matching with palo alto log
    return ["id", "description", "reference", "depends", "category", "evasive" "subcategory", "bandwith", "risk", "misuse", "ports", "file_transfer",
    "technology", "tunnel", "malware", "known_vulnerabilities", "widly_used", "saas", "certifications", "data_breach", "ip_based_restriction", "poor_financial_viability",
    "poor_terms_of_service"]
  end

  def attribute_values
    result = []
    result << @app_id
    result << @description
    result << @reference
    result << @depends
    result << @category
    result << @evasive
    result << @subcategory
    result << @bandwith
    result << @risk
    result << @misuse
    result << @ports
    result << @file_transfer
    result << @technology
    result << @malware
    result << @tunnel
    result << @known_vulnerabilities
    result << @widly_used
    result << @saas
    result << @certifications
    result << @data_breach
    result << @ip_based_restriction
    result << @poor_financial_viability
    result << @poor_terms_of_service
    return result
  end

end

def load_file(html_file)
  @doc = Nokogiri.HTML(File.open(html_file))
end

def parse_list
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

end

def parse_details(app_id="")
  table = @doc.search(".popInfoPanelStyle")
  descr = table.search("div.idented")
  item = DetailItem.new
  item.app_id = app_id
  #Description, Reference, Depends
  item.description = descr[0].inner_html.gsub(/\t+/, "").gsub(/\n+/, "")
  item.reference = descr[1].inner_html.gsub(/\t+/, "").gsub(/\n+/, "")
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
  @list_array << item
end

#Writing LIST and Details CSV
def write_csv(file_name, csv_class, array_of_list_items)
  CSV.open(file_name, "wb") do |csv|
    csv << csv_class.attribute_names
    array_of_list_items.each do |item|
        csv << item.attribute_values
    end
  end
end


def test_loading_and_parsing
    load_file(SHORT_LIST)
    parse_list
    #write_csv("applipedia_list.csv", ListItem, @list_array)

    #Full Details - Length 19
    load_file(FULL_DETAILS)
    parse_details
    #Medium Details - Length 14
    load_file(MEDIUM_DETAILS)
    parse_details
    #Low Details - No lenght at all, skips already on description
    load_file(LOW_DETAILS)
    parse_details
    #write_csv("applipedia_details.csv", DetailItem, @list_array)
end

test_loading_and_parsing
puts "All test passed"