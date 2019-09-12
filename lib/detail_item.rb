class DetailItem
    attr_accessor :app_id, :app_name, :description, :reference, :depends, :category, :evasive, :subcategory, :bandwith, :risk, :misuse, :ports, :file_transfer,
    :technology, :tunnel, :malware, :known_vulnerabilities, :widly_used, :saas, :certifications, :data_breach, :ip_based_restriction, :poor_financial_viability,
    :poor_terms_of_service
  
    def initialize
    end
  
    def attribute_names
      #id and app and not app_id or name are used because of matching with palo alto threat log
      return ["id", "app", "description", "reference", "depends", "category", "evasive", "subcategory", "bandwith", "risk", "misuse", "ports", "file_transfer",
      "technology", "tunnel", "malware", "known_vulnerabilities", "widly_used", "saas", "certifications", "data_breach", "ip_based_restriction", "poor_financial_viability",
      "poor_terms_of_service"]
    end
  
    def attribute_values
      result = []
      result << @app_id
      result << @app_name
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