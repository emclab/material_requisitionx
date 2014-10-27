# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_of_materialx_bom, :class => 'BillOfMaterialx::Bom' do
    name "MyString"
    part_num "MyString"
    spec "MyText"
    project_id 1
    qty 1
    unit "MyString"
    manufacturer_id 1
    supplier_id 1
    last_updated_by_id 1
    void false
    received false
    receiving_date "2014-04-02"
    actual_receiving_date "2014-04-02"
    order_date "2014-04-02"
    status_id 1
    wf_state "MyString"
    wfid "MyString"
    brief_note "MyText"
  end
end
