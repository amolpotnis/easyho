class AddRememberTokenToMainUsers < ActiveRecord::Migration
  def change
    add_column :main_users, :remember_token, :string
    add_index  :main_users, :remember_token
  end
end
