module MaterialRequisitionx
  class MaterialItem < ActiveRecord::Base
    attr_accessor :unit_price, :stock_qty, :item_name_autocomplete
    attr_accessible :brief_note, :item_id, :qty, :unit, :requisition_id, :name, :spec,
                    :unit_price, :stock_qty,
                    :as => :role_new
    attr_accessible :brief_note, 
                    :unit_price, :stock_qty,
                    :as => :role_update
    belongs_to :item, :class_name => MaterialRequisitionx.item_class.to_s
    belongs_to :requisition, :class_name => 'MaterialRequisitionx::Requisition'
    
    validates :qty, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :unit, :name, :spec, :presence => true
    validates :name, :uniqueness => {:scope => :requisition_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :item_id, :numericality => {:only_integer => true, :greater_than => 0}, :if => 'item_id.present?'
=begin    
    def item_name_autocomplete
      self.item.try(:name)
    end

    def item_name_autocomplete=(name)
      self.item = MaterialRequisitionx.item_class.find_by_name(name) if name.present?
    end
=end        
  end
end
