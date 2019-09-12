class CSVWorker
    
    def self.read_csv(file_name)
        return CSV.read(file_name)
    end

    def self.write_csv(file_name, array_of_list_items)
        begin
            CSV.open(file_name, "wb", {:quote_char => '"', :force_quotes => true}) do |csv|
                #write header
                csv << array_of_list_items.first.attribute_names
                #write values
                array_of_list_items.each do |item|
                    csv << item.attribute_values
                end
            end
        rescue Errno::ENOENT => e
            puts "File or directory #{file_name} doesn't exist."
            return "ERROR"
        rescue Errno::EACCES => e
            puts "Can't write #{file_name}. No permission or File used by another process"
            return "ERROR"
        rescue SystemCallError => e
            puts e.class # => Errno::ENOENT
            puts e.class.superclass # => SystemCallError
            puts e.class.superclass.superclass # => StandardError
            return "ERROR"
        end
        return "SUCCESS"
    end
end