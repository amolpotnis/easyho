class CreatePchSections < ActiveRecord::Migration
  def change
    create_table :pch_sections do |t|
      t.string :displayname
      t.integer :sec_id
      t.timestamps
    end
  end
end
