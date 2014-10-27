# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_checkoutx_checkout, :class => 'ItemCheckoutx::Checkout' do
    item_id 1
    #out_qty 1
    #last_updated_by_id 1
    name 'a product'
    item_spec 'item specs'
    #requested_by_id 1
    request_date "2013-11-17"
    brief_note "My note Text"
    wf_state "My state String"
    requested_qty 1
    #checkout_by_id 1
    unit 'piece'
  end
end
