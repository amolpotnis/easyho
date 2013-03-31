class CreatePatientFollowups < ActiveRecord::Migration
  def change
    create_table :patient_followups do |t|
      t.integer :patient_id
      t.text :observations
      t.text :medicines

      t.timestamps
    end
  end
end
