class CreatePchRecords < ActiveRecord::Migration
  def change
    create_table :pch_records do |t|
      t.integer :patient_id
      t.integer :pch_sec_id
      t.text :htmltext
      t.timestamps
    end
  end
end
