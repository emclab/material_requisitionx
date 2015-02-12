module MaterialRequisitionx
  class MaterialItem < ActiveRecord::Base
    attr_accessor :unit_price, :stock_qty, :item_name_autocomplete, :item_id
    attr_accessible :brief_note, :item_id, :qty, :unit, :requisition_id, :name, :spec, :item_name_autocomplete,
                    :unit_price, :stock_qty,
                    :as => :role_new
    attr_accessible :brief_note, :item_name_autocomplete, :spec, :unit, :qty, :name,
                    :unit_price, :stock_qty,
                    :as => :role_update
    belongs_to :requisition, :class_name => 'MaterialRequisitionx::Requisition'
    
    validates :qty, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :unit, :name, :spec, :presence => true
    validates :name, :uniqueness => {:scope => :requisition_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    
  end
end
