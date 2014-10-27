module MaterialRequisitionx
  require 'workflow'
  class Requisition < ActiveRecord::Base
    
    include Workflow
    workflow_column :wf_state
    
    attr_accessor :last_updated_by_name, :field_changed, :id_noupdate, :wf_comment, :wf_state_noupdate, :wf_event, :skip_wf_noupdate
    attr_accessible :fullfilled, :requisition_date, :last_updated_by_id, :project_id, :request_date, :requested_by_id, :skip_wf, :wf_state, :cost_total, :date_needed,
                    :purpose, :field_changed, :material_items_attributes, :approved, :approved_date, :approved_by_id, :fulfilled, :brief_note,
                    :as => :role_new
    attr_accessible :approved, :approved_by_id, :approved_date, :checkedout, :fulfill_date, :project_id, :request_date, :cost_total, :date_needed, :purpose, :brief_note,
                    :requested_by_id, :skip_wf, :wf_state, :field_changed, :material_items_attributes, :approved, :approved_date, :approved_by_id, :fulfilled,
                    :id_noupdate, :wf_comment, :fulfilled_by_id,
                    :as => :role_update
    
    attr_accessor :project_id_s, :start_date_s, :end_date_s, :approved_s, :requested_by_id_s, :time_frame_s, :purpose_s, :customer_id_s, :fulfilled, :product_name_s, 
                  :spec_s, :fulfilled_by_id_s
                  
    attr_accessible :project_id_s, :start_date_s, :end_date_s, :approved_s, :requested_by_id_s, :time_frame_s, :purpose_s, :customer_id_s, :fulfilled, :spec_s,
                    :product_name_s, :fulfilled_by_id_s,
                    :as => :role_search_stats
                                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :approved_by, :class_name => 'Authentify::User'
    belongs_to :project, :class_name => MaterialRequisitionx.project_class.to_s
    has_many :material_items, :class_name => 'MaterialRequisitionx::MaterialItem'
    accepts_nested_attributes_for :material_items, :allow_destroy => true
    
    validates :project_id, :requested_by_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :purpose, :request_date, :date_needed, :presence => true  
    validates :cost_total, :numericality => {:greater_than_or_equal_to => 0}, :if => 'cost_total.present?'
    validate :dynamic_validate 
        #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'material_requisitionx')
      eval(wf) if wf.present?
    end        
                                          
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_requisition_' + self.wf_state, 'material_requisitionx')
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end

    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('requisition_wf_pdef', 'material_requisitionx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :reviewing
        end
        state :reviewing do
          event :manager_approve, :transitions_to => :approved
          event :manager_reject, :transitions_to => :rejected
        end
        state :approved do
          event :fulfill, :transitions_to => :fulfilled
        end
        state :rejected
        state :fulfilled
        
      end
    end
  end
end
