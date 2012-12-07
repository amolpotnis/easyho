class AddMoreitemsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :doctor_id, :integer
    add_column :patients, :opd_number, :string
    add_index  :patients, :opd_number
  end
end
