class AddPasswordDigestToMainUsers < ActiveRecord::Migration
  def change
    add_column :main_users, :password_digest, :string
  end
end
