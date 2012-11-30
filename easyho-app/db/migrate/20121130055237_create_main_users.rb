class CreateMainUsers < ActiveRecord::Migration
  def change
    create_table :main_users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :mobile
      t.string :status
      t.boolean :isadmin
      t.date :dob
      t.datetime :lastlogin
      t.timestamps
    end
  end
end
