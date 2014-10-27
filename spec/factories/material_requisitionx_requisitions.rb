# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :material_requisitionx_requisition, :class => 'MaterialRequisitionx::Requisition' do
    project_id 1
    request_date "2014-10-21"
    approved false
    approved_date "2014-10-21"
    approved_by_id 1
    last_updated_by_id 1
    wf_state "MyString"
    requested_by_id 1
    fulfilled false
    skip_wf false
    purpose 'my purpose'
    brief_note 'my notes'
    date_needed Date.today
    
  end
end
