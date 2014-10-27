class CreateMaterialRequisitionxRequisitions < ActiveRecord::Migration
  def change
    create_table :material_requisitionx_requisitions do |t|
      t.integer :project_id
      t.string :purpose
      t.date :request_date
      t.boolean :approved, :default => false
      t.date :approved_date
      t.integer :approved_by_id
      t.integer :last_updated_by_id
      t.string :wf_state
      t.integer :requested_by_id
      t.date :fulfill_date
      t.boolean :fulfilled, :default => false
      t.integer :fulfilled_by_id 
      t.boolean :skip_wf, :default => false
      t.decimal :cost_total, :precision => 10, :scale => 2
      t.date :date_needed
      t.text :brief_note

      t.timestamps
    end
    
    add_index :material_requisitionx_requisitions, :project_id
    add_index :material_requisitionx_requisitions, :requested_by_id
    add_index :material_requisitionx_requisitions, :wf_state
    add_index :material_requisitionx_requisitions, :approved
    add_index :material_requisitionx_requisitions, :fulfilled
    add_index :material_requisitionx_requisitions, :fulfilled_by_id
    add_index :material_requisitionx_requisitions, :skip_wf
  end
end
