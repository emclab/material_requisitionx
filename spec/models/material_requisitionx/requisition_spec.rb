require 'rails_helper'

module MaterialRequisitionx
  RSpec.describe Requisition, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:material_requisitionx_requisition)
      expect(c).to be_valid
    end
    
    it "should reject nil project id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, project_id: nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, project_id: 0)
      expect(c).not_to be_valid
    end
    
    it "should reject nil purpose" do
      c = FactoryGirl.build(:material_requisitionx_requisition, purpose: nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 requested_by_id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :requested_by_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject nil in_request_date" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :request_date => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil date_needed" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :date_needed => nil)
      expect(c).not_to be_valid
    end
    
    it "should take nil skip_wf" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :skip_wf => nil)
      expect(c).to be_valid
    end
  end
end
