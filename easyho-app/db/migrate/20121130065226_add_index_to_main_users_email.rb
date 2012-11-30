class AddIndexToMainUsersEmail < ActiveRecord::Migration
  def change
    add_index :main_users, :email, unique: true
  end
end
