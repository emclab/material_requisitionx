# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :material_requisitionx_material_item, :class => 'MaterialRequisitionx::MaterialItem' do
    requisition_id 1
    item_id 1
    name 'a product'
    spec 'prod spec'
    qty 1
    brief_note "MyString"
    unit 'unit'
  end
end
