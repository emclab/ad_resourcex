require 'rails_helper'

module AdResourcex
  RSpec.describe Resource, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:ad_resourcex_resource)
      expect(c).to be_valid
    end
    
    it "should reject nil about price if standard_price present" do
      c1 = FactoryGirl.create(:ad_resourcex_resource, :standard_price => 10)
      c = FactoryGirl.build(:ad_resourcex_resource, :about_price => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:ad_resourcex_resource, :name => 'A name')
      c = FactoryGirl.build(:ad_resourcex_resource, :name => 'a name')
      expect(c).not_to be_valid
    end
    
    it "should accept nil status_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :status_id => nil)
      expect(c).to be_valid
    end
    
    it "should reject 0 status_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :status_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject nil resource_location" do
      c = FactoryGirl.build(:ad_resourcex_resource, :location => nil)
      expect(c).not_to be_valid
    end
    
    it "should take nil category_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :category_id => nil)
      expect(c).to be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :category_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 standard_price" do
      c = FactoryGirl.build(:ad_resourcex_resource, :standard_price => 0)
      expect(c).not_to be_valid
    end
  end
end
