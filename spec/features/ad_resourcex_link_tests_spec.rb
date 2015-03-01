require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /ad_resourcex_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "AdResourcex::Resource.where(:in_service => true).order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'ad_resourcex_resources', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_ad_resource', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      
      log = FactoryGirl.create(:commonx_log, :resource_name => 'ad_resourcex_resources')
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    
    it "should work" do
      qs = FactoryGirl.create(:ad_resourcex_resource, :in_service => true, :last_updated_by_id => @u.id)
      
      visit ad_resourcex.resources_path
      click_link qs.id.to_s
      expect(page).to have_content('Resource Info')
      click_link 'New Log'
      expect(page).to have_content('Log')
      #save_and_open_page
      visit ad_resourcex.resources_path() 
      save_and_open_page
      click_link 'Edit'
      #save_and_open_page
      expect(page).to have_content('Edit Resource')
      fill_in 'resource_name', :with => 'new name'
      click_button 'Save'
      save_and_open_page
      #wrong data
      visit ad_resourcex.resources_path() 
      click_link 'Edit'
      expect(page).to have_content('Edit Resource')
      fill_in 'resource_location', :with => ''
      click_button 'Save'
      save_and_open_page
      
      visit ad_resourcex.resources_path
      save_and_open_page
      expect(page).to have_content('Resources')
      click_link 'New Resource'
      save_and_open_page
      expect(page).to have_content('New Resource')
      fill_in 'resource_name', :with => 'new Resource'
      fill_in 'resource_location', :with => 'this is the address for the Resource'
      click_button 'Save'
      save_and_open_page
      #wrong data
      visit ad_resourcex.resources_path
      save_and_open_page
      expect(page).to have_content('Resources')
      click_link 'New Resource'
      save_and_open_page
      expect(page).to have_content('New Resource')
      fill_in 'resource_name', :with => 'this is the address for the Resource'
      fill_in 'resource_location', :with => ''
      click_button 'Save'
      save_and_open_page
    end
    
  end
end
