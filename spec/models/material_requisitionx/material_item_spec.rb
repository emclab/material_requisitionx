require 'rails_helper'

module MaterialRequisitionx
  RSpec.describe MaterialItem , type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:material_requisitionx_material_item)
      expect(c).to be_valid
    end
    
    it "should reject nil unit" do
      c = FactoryGirl.build(:material_requisitionx_material_item, unit: nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:material_requisitionx_material_item, name: nil)
      expect(c).not_to be_valid
    end
    
    it "should reject duplicate name" do
      c1 = FactoryGirl.create(:material_requisitionx_material_item, name: 'NIl')
      c = FactoryGirl.build(:material_requisitionx_material_item, name: 'nil')
      expect(c).not_to be_valid
    end
    
    it "should reject nil spec" do
      c = FactoryGirl.build(:material_requisitionx_material_item, spec: nil)
      expect(c).not_to be_valid
    end
    
    #it "should reject 0 requisition_id" do
    #  c = FactoryGirl.build(:material_requisitionx_material_item, :requisition_id => 0)
    #  expect(c).not_to be_valid
    #end
    
    it "should reject 0 out qty" do
      c = FactoryGirl.build(:material_requisitionx_material_item, :qty => 0)
      expect(c).not_to be_valid
    end
  end
end
