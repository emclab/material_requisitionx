require "material_requisitionx/engine"

module MaterialRequisitionx
  mattr_accessor :project_class, :item_class
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.item_class
    @@item_class.constantize
  end
end
