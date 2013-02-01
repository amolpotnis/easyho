class RenameSectionidToDisplayorder < ActiveRecord::Migration
  def up
    rename_column :pch_sections, :sec_id, :displayorder
  end

  def down
    rename_column :pch_sections, :displayorder, :sec_id
  end
end
