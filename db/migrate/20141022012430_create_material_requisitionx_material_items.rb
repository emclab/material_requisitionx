class CreateMaterialRequisitionxMaterialItems < ActiveRecord::Migration
  def change
    create_table :material_requisitionx_material_items do |t|
      t.integer :requisition_id
      t.integer :item_id
      t.string :name
      t.string :spec
      t.integer :qty
      t.string :unit
      t.string :brief_note

      t.timestamps
    end
    
    add_index :material_requisitionx_material_items, :name
    add_index :material_requisitionx_material_items, :spec
    add_index :material_requisitionx_material_items, :item_id
    add_index :material_requisitionx_material_items, :requisition_id
  end
end
