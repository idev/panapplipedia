class ListItem
    attr_accessor :app_id, :name, :ottawagroup, :category, :subcategory, :risklevel, :technology
  
    def initialize
    end
  
    def attribute_names
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