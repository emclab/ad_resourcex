require "ad_resourcex/engine"

module AdResourcex
  
  mattr_accessor :supplier_class
  
  def self.supplier_class
    @@supplier_class.constantize
  end
end
