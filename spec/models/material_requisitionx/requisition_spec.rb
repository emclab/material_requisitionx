require 'spec_helper'

module MaterialRequisitionx
  describe Requisition do
    it "should be OK" do
      c = FactoryGirl.create(:material_requisitionx_requisition)
      c.should be_valid
    end
    
    it "should reject nil project id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, project_id: nil)
      c.should_not be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, project_id: 0)
      c.should_not be_valid
    end
    
    it "should reject nil purpose" do
      c = FactoryGirl.build(:material_requisitionx_requisition, purpose: nil)
      c.should_not be_valid
    end
    
    it "should reject 0 requested_by_id" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :requested_by_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil in_request_date" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :request_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil date_needed" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :date_needed => nil)
      c.should_not be_valid
    end
    
    it "should take nil skip_wf" do
      c = FactoryGirl.build(:material_requisitionx_requisition, :skip_wf => nil)
      c.should be_valid
    end
  end
end
