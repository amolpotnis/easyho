class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :email
      t.string :mobile
      t.string :homeaddress
      t.string :homephone
      t.date :dob
      t.string :jobdescription
      t.string :jobaddress
      t.string :jobphone
      t.string :jobemail
      t.timestamps
    end
  end
end
