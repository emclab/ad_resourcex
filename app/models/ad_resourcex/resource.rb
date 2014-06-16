module AdResourcex
  class Resource < ActiveRecord::Base
    attr_accessor :last_updated_by_name, :category_name, :status_name, :in_service_noupdate
    attr_accessible :about_price, :category_id, :dimension, :location, :name, :resource_desp, :standard_price, :status_id, :in_service, :service_start_date,
                    :service_end_date,
                    :as => :role_new
    attr_accessible :about_price, :category_id, :dimension, :location, :name, :resource_desp, :standard_price, :status_id, :in_service, :service_start_date,
                    :service_end_date,
                    :last_updated_by_name, :status_name, :category_name, :in_service_noupdate,
                    :as => :role_update
    
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :supplier, :class_name => AdResourcex.supplier_class.to_s
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :location, :presence => true
    validates :about_price, :presence => true, :if => 'standard_price.present?'
    validates :standard_price, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'standard_price.present?'
    validates :status_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'status_id.present?'
    validates :category_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'category_id.present?'
    validates :supplier_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'supplier_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'ad_resourcex')
      eval(wf) if wf.present?
    end
  end
end
