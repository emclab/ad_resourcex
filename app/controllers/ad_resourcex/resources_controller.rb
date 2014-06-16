require_dependency "ad_resourcex/application_controller"

module AdResourcex
  class ResourcesController < ApplicationController
    before_filter :require_employee
    
    def index
      @title = t('Resources')
      @resources =  params[:ad_resourcex_resources][:model_ar_r]
      @resources = @resources.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('resource_index_view', 'ad_resourcex')
    end

    def new
      @title = t('New Resource')
      @resource = AdResourcex::Resource.new
      @erb_code = find_config_const('resource_new_view', 'ad_resourcex')
    end


    def create
      @resource = AdResourcex::Resource.new(params[:resource], :as => :role_new)
      @resource.last_updated_by_id = session[:user_id]
      if @resource.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('resource_new_view', 'ad_resourcex')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Resource')
      @resource = AdResourcex::Resource.find_by_id(params[:id])
      @erb_code = find_config_const('resource_edit_view', 'ad_resourcex')
    end

    def update
        @resource = AdResourcex::Resource.find_by_id(params[:id])
        @resource.last_updated_by_id = session[:user_id]
        if @resource.update_attributes(params[:resource], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('resource_edit_view', 'ad_resourcex')
          render 'edit'
        end
    end

    def show
      @title = t('Resource Info')
      @resource = AdResourcex::Resource.find_by_id(params[:id])
      @erb_code = find_config_const('resource_show_view', 'ad_resourcex')
    end
    
    protected

  end
end
