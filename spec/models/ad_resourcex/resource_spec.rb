require 'spec_helper'

module AdResourcex
  describe Resource do
    it "should be OK" do
      c = FactoryGirl.build(:ad_resourcex_resource)
      c.should be_valid
    end
    
    it "should reject nil about price if standard_price present" do
      c1 = FactoryGirl.create(:ad_resourcex_resource, :standard_price => 10)
      c = FactoryGirl.build(:ad_resourcex_resource, :about_price => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:ad_resourcex_resource, :name => 'A name')
      c = FactoryGirl.build(:ad_resourcex_resource, :name => 'a name')
      c.should_not be_valid
    end
    
    it "should accept nil status_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :status_id => nil)
      c.should be_valid
    end
    
    it "should reject 0 status_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :status_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil resource_location" do
      c = FactoryGirl.build(:ad_resourcex_resource, :location => nil)
      c.should_not be_valid
    end
    
    it "should take nil category_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :category_id => nil)
      c.should be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:ad_resourcex_resource, :category_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 standard_price" do
      c = FactoryGirl.build(:ad_resourcex_resource, :standard_price => 0)
      c.should_not be_valid
    end
  end
end
