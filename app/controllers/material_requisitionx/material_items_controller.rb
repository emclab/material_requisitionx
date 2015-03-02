require_dependency "material_requisitionx/application_controller"

module MaterialRequisitionx
  class MaterialItemsController < ApplicationController
    before_action :require_employee
    before_action :load_parent_record
    
    def index
      @title = t('Requisition Items')
      @material_items = params[:material_requisitionx_material_items][:model_ar_r]
      @material_items = @material_items.where(:requisition_id => @requisition.id) #@requisition has to be present
      @material_items = @material_items.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('material_item_index_view', 'material_requisitionx')
    end
    protected
    def load_parent_record
      @requisition = MaterialRequisitionx::Requisition.find_by_id(MaterialRequisitionx::MaterialItem.find_by_id(params[:id]).requisition_id) if params[:id].present?
      @requisition = MaterialRequisitionx::Requisition.find_by_id(params[:requisition_id].to_i) if params[:requisition_id].present?
    end
  end
end
