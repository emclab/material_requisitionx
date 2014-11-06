# This migration comes from requisition_checkoutx (originally 20141023173040)
class CreateRequisitionCheckoutxCheckouts < ActiveRecord::Migration
  def change
    create_table :requisition_checkoutx_checkouts do |t|
      t.integer :project_id
      t.integer :requisition_id
      t.integer :item_id
      t.integer :checkout_qty
      t.string :unit
      t.integer :checkout_by_id
      t.date :checkout_date
      t.string :brief_note
      t.integer :last_updated_by_id
      t.string :wf_state
      t.string :whs_string   #warehouse name. used to allow access to each individual whs.
      t.integer :warehouse_item_id

      t.timestamps
    end
    
    add_index :requisition_checkoutx_checkouts, :project_id
    add_index :requisition_checkoutx_checkouts, :item_id
    add_index :requisition_checkoutx_checkouts, :requisition_id
    add_index :requisition_checkoutx_checkouts, :checkout_by_id
    add_index :requisition_checkoutx_checkouts, :whs_string
    add_index :requisition_checkoutx_checkouts, :wf_state
    add_index :requisition_checkoutx_checkouts, :warehouse_item_id
  end
end
