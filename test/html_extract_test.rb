require 'rubygems'
require 'nokogiri'

#already nokogiri
LIST_FILE = "list_test.txt"
LIST_SMALL = "list_test_small.txt"
DETAIL_FILE = "detail_test.txt"

def open_file

    doc = File.open(LIST_FILE){ |f| Nokogiri::XML(f) }
    table = doc.css("#dataTable")

    table.search('tr').each do |tr|
        cells = tr.search('td')
        cnt = 0
        cells.each do |cell|
            img = cell.search("img")
            img.each do |c|
                #pp c.attr("title")
                puts cnt
                text = cell.text.strip!
                puts text
                cnt += 1
            end
          end
      end

    #pp table
    #pp doc.css("a#DetailLink").text.gsub!(/\s+/, ' ')
    #pp doc.css("#bodyScrollingTable > tr:nth-child(1) > td:nth-child(2)").text
    
end


def open_file2

    doc = File.open(LIST_SMALL){ |f| Nokogiri::XML(f) }
    table = doc.css("#bodyScrollingTable")
    cnt = 0
    tr = table.search('tr')
    puts tr.size
    tr.search("td").children.select(&:element?).each do |cell|
        puts "xxxxx"
        pp cell
        puts cell.text.gsub!(/\t+/, ' ')
        cnt += 1
        puts cnt
        puts "-----"
    end
    #table.search('tr').each do |tr|
        #cells = tr.search('td')
        #puts tr
        #puts tr

    #  end

    #pp table
    #pp doc.css("a#DetailLink").text.gsub!(/\s+/, ' ')
    #pp doc.css("#bodyScrollingTable > tr:nth-child(1) > td:nth-child(2)").text
    
end

#open_file
open_file2

#neuer Plan, nur die IDs auslesen und alle Details aus der Detail View!