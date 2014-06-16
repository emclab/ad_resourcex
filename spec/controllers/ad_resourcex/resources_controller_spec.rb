require 'spec_helper'

module AdResourcex
  describe ResourcesController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
  
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all projects for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourcex::Resource.where(:in_service => true).order('id')")     
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource, :in_service => true, :last_updated_by_id => @u.id)
        qs1 = FactoryGirl.create(:ad_resourcex_resource, :in_service => true, :last_updated_by_id => @u.id,  :name => 'newnew')
        get 'index' , {:use_route => :ad_resourcex}
        assigns(:resources).should =~ [qs, qs1]       
      end
      
      it "should return in service project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourcex::Resource.where(:in_service => true).order('id')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource, :in_service => true, :last_updated_by_id => @u.id)
        qs1 = FactoryGirl.create(:ad_resourcex_resource, :in_service => false, :last_updated_by_id => @u.id,  :name => 'newnew')
        get 'index' , {:use_route => :ad_resourcex}
        assigns(:resources).should eq([qs])
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :ad_resourcex}
        response.should be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:ad_resourcex_resource)
        get 'create' , {:use_route => :ad_resourcex,  :resource => qs}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:ad_resourcex_resource, :name => nil)
        get 'create' , {:use_route => :ad_resourcex,  :resource => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource, :last_updated_by_id => @u.id)
        get 'edit' , {:use_route => :ad_resourcex,  :id => qs.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource, :last_updated_by_id => @u.id)
        get 'update' , {:use_route => :ad_resourcex,  :id => qs.id, :resource => {:name => 'newnew'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource, :last_updated_by_id => @u.id)
        get 'update' , {:use_route => :ad_resourcex,  :id => qs.id, :resource => {:name => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:ad_resourcex_resource)
        get 'show' , {:use_route => :ad_resourcex,  :id => qs.id}
        response.should be_success
      end
    end
  end
end
