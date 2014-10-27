require_dependency "material_requisitionx/application_controller"

module MaterialRequisitionx
  class RequisitionsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Requisition Items')
      @requisitions = params[:material_requisitionx_requisitions][:model_ar_r]
      @requisitions = @requisitions.where(:project_id => @project.id) if @project
      @requisitions = @requisitions.where(:wf_state => params[:wf_state]) if params[:wf_state]
      @requisitions = @requisitions.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('requisition_index_view', 'material_requisitionx')
    end
  
    def new
      @title = t('New Requisition Item')
      @requisition = MaterialRequisitionx::Requisition.new()
      @requisition.material_items.build
      return_callback_values()  #return @digi_keys[] and @quote_ids[]
      @erb_code = find_config_const('requisition_new_view', 'material_requisitionx')
    end
  
    def create
      @requisition = MaterialRequisitionx::Requisition.new(params[:requisition], :as => :role_new)
      @requisition.last_updated_by_id = session[:user_id]
      @requisition.requested_by_id = session[:user_id]
      if @requisition.save 
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('requisition_new_view', 'material_requisitionx')
        @project = MaterialRequisitionx.project_class.find_by_id(MaterialRequisitionx::Requisition.find_by_id(params[:requisition][:project_id])) if params[:requisition].present? && params[:requisition][:project_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end 
    end
  
    def edit
      @title = t('Update Requisition Item')
      @requisition = MaterialRequisitionx::Requisition.find_by_id(params[:id])
      return_callback_values()  #return @digi_keys[] and @quote_ids[]
      @erb_code = find_config_const('requisition_edit_view', 'material_requisitionx')
      if !@requisition.skip_wf && @requisition.wf_state.present? && @requisition.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end

    end
  
    def update
      @requisition = MaterialRequisitionx::Requisition.find_by_id(params[:id])
      if !(!@requisition.skip_wf && @requisition.wf_state.present? && @requisition.current_state != :initial_state)
        if  @requisition.update_attributes(params[:requisition], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          @erb_code = find_config_const('requisition_edit_view', 'material_requisitionx')
          flash[:notice] = t('Data Error. Not Updated!')
          render 'edit'
        end
      end
    end
    
    def show
      @title = t('Requisition Item Info')
      @requisition = MaterialRequisitionx::Requisition.find_by_id(params[:id])
      @erb_code = find_config_const('requisition_show_view', 'material_requisitionx')
    end

    def destroy
      MaterialRequisitionx::Requisition.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def list_open_process  
      index()
      @requisitions = return_open_process(@requisitions, find_config_const('requisition_wf_final_state_string', 'material_requisitionx'))  # ModelName_wf_final_state_string
    end
    
    def list_items
      index()
      @requisitions
    end

    protected
    def load_parent_record
      @project = MaterialRequisitionx.project_class.find_by_id(MaterialRequisitionx::Requisition.find_by_id(params[:id]).project_id) if params[:id].present?
      @project = MaterialRequisitionx.project_class.find_by_id(params[:project_id].to_i) if params[:project_id].present?
    end
    
    def return_callback_values
      return if params[:requisition].blank? or params[:requisition][:material_items_attributes].blank?
      @digi_keys = []   #digi key inserted into ID for nested field
      @auto_strings = []
      params[:requisition][:material_items_attributes].keys.each do |k|
        if params[:requisition][:material_items_attributes][k][:_destroy] == 'false'
          @digi_keys << k.to_s
          @auto_strings << params[:requisition][:material_items_attributes][k][:item_name_autocomplete]
        end
      end
    end
    
  end
end
